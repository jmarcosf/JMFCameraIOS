/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController.m                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filters View Controller Class implementation file         */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FiltersViewController.h"
#import "JMFCameraIOS_FilterTVPickerCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_FILTERTV_NORMAL_CELL_IDENTIFIER         @"FilterTVNormalCellIdentifier"
#define IDS_FILTERTV_PICKER_CELL_IDENTIFIER         @"FilterTVPickerCellIdentifier"
#define ID_CELL_SWITCH_TAG                          4777

#define IDC_UITOOLBAR_BUTTON_CANCEL_INDEX           0
#define IDC_UITOOLBAR_BUTTON_CLEAR_INDEX            1
#define IDC_UITOOLBAR_BUTTON_APPLY_INDEX            2
#define IDC_UITOOLBAR_BUTTON_SAVE_INDEX             3

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FiltersViewController ()
{
    NSFetchedResultsController* fetchedResultsController;
    NSMutableArray*             filtersArray;
    long                        iPickerViewSection;
    int                         iSectionToDelete;
    BOOL                        bModified;
    BOOL                        bReloadData;
}
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Implemantation                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FiltersViewController

#pragma mark - Initialization Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithPhoto:andImage:inModel:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image inModel:(JMFCoreDataStack *)model
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.photo = photo;
        self.image = image;
        self.model = model;
    }
    return self;
}

#pragma mark - UIViewController Override Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIViewController Override Methods                                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewDidLoad                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector( addFilter: )];
    self.navigationItem.hidesBackButton = YES;
    self.title = NSLocalizedString( @"IDS_FILTERS", nil );
    iSectionToDelete = -1;
    bModified = bReloadData = NO;
    
    if( self.image == nil ) self.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboSourceImage.image = self.image;
    self.iboTargetImage.image = ( self.photo.filteredImageUrl == nil || [self.photo.filteredImageUrl isEqualToString:@""] )
                                ? [UIImage imageNamed:@"NoImage.jpg"]
                                : [UIImage imageWithContentsOfFile:self.photo.filteredImageUrl];
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setTitle:NSLocalizedString( @"IDS_CANCEL", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setTitle:NSLocalizedString( @"IDS_CLEAR", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setTitle:NSLocalizedString( @"IDS_APPLY", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setTitle:NSLocalizedString( @"IDS_SAVE",  nil )];
    
    //TableView
    [self.iboFilterTable registerClass:[UITableViewCell class] forCellReuseIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER];
    [self.iboFilterTable registerClass:[JMFCameraIOS_FilterTVPickerCell class] forCellReuseIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER];
    self.iboFilterTable.sectionHeaderHeight = 2.0;
    self.iboFilterTable.sectionFooterHeight = 20.0;
    self.iboFilterTable.delegate = self;
    self.iboFilterTable.dataSource = self;
    
    //Filters Array
    filtersArray = [[CIFilter filterNamesInCategories:nil]mutableCopy];
    [filtersArray insertObject:IDS_FILTER_NONE atIndex:0];

    iPickerViewSection = -1;
    
    //Query
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[JMFFilter entityName]];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    request.sortDescriptors = @[];
    request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.model.context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    fetchedResultsController.delegate = self;
    NSError *error;
    [fetchedResultsController performFetch:&error];
    if( error && APPDEBUG ) NSLog( @"Fetch Filters error: %@", error );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewWillAppear                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iboSourceImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iboSourceImage.frame = CGRectMake( 4, 4, 154, 154 );
    [self.iboSourceImage setClipsToBounds:YES];
    self.iboTargetImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iboTargetImage.frame = CGRectMake( 162, 4, 154, 154 );
    [self.iboTargetImage setClipsToBounds:YES];
//    self.iboActivityIndicator.hidden = YES;
//    [self.iboActivityIndicator stopAnimating];
    
    [self enableButtons];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  didReceiveMemoryWarning                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITabBarDelegate Methods                                               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tabBar:didSelectItem:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item
{
    switch( item.tag )
    {
        case IDC_UITOOLBAR_BUTTON_CANCEL_INDEX: [self onCancelClicked]; break;
        case IDC_UITOOLBAR_BUTTON_CLEAR_INDEX:  [self onClearClicked];  break;
        case IDC_UITOOLBAR_BUTTON_APPLY_INDEX:  [self onApplyClicked];  break;
        case IDC_UITOOLBAR_BUTTON_SAVE_INDEX:   [self onSaveClicked];   break;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSFetchedResultsControllerDelegate Methods                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controllerWillChangeContent:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.iboFilterTable beginUpdates];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controller:didChangeSection:atIndex:forChangeType:                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex orChangeType:(NSFetchedResultsChangeType)type
{
    switch( type )
    {
        case NSFetchedResultsChangeInsert:
            [self.iboFilterTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.iboFilterTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    
    int iSection = newIndexPath.section;
    int iRow = newIndexPath.row;
    
    int iOldSection = indexPath.section;
    int iOldRow = indexPath.row;
    
    switch( type )
    {
        case NSFetchedResultsChangeInsert:
            [self.iboFilterTable insertSections:[NSIndexSet indexSetWithIndex:self.iboFilterTable.numberOfSections] withRowAnimation:UITableViewRowAnimationFade];
//          [self.iboFilterTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
        {
//          [self.iboFilterTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if( iSectionToDelete != -1 )
            {
                int idx = ( iSectionToDelete == -2 ) ? indexPath.row : iSectionToDelete;
                [self.iboFilterTable deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationFade];
                if( iSectionToDelete != -2 ) iSectionToDelete = -1, bReloadData = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate:
//          [self.iboFilterTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
//          [self.iboFilterTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.section inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//          [self.iboFilterTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.section inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//          [self.iboFilterTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.section inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controllerDidChangeContent:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.iboFilterTable endUpdates];
    if( iSectionToDelete == -2 ) iSectionToDelete = -1;
    bModified = YES;
    [self enableButtons];
    if( bReloadData ) [self.iboFilterTable reloadData];
    bReloadData = NO;
}

#pragma mark - UITableViewDataSource
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewDataSource Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfSectionsInTableView                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[fetchedResultsController fetchedObjects]count];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:titleForHeaderInSection:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), section + 1];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:numberOfRowsInSection:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = ( iPickerViewSection != -1 && section == iPickerViewSection ) ? 2 : 1;
    return rows;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:cellForRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    int iSection = indexPath.section;
    int iRow = indexPath.row;
    if( iPickerViewSection != -1 && indexPath.section == iPickerViewSection && indexPath.row == 1 )
    {
        JMFCameraIOS_FilterTVPickerCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.imageView.image = nil;
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
        cell.pickerView.showsSelectionIndicator = YES;
        return cell;
    }
    else
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"ArrowDown.png"];
        cell.textLabel.text = filter.name;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        UISwitch* cellSwitch = (UISwitch*)[cell viewWithTag:ID_CELL_SWITCH_TAG];
        if( cellSwitch == nil ) cellSwitch = [[UISwitch alloc]init];
        else [cellSwitch removeTarget:self action:@selector( onSwitchChanged: ) forControlEvents:UIControlEventValueChanged];
        cellSwitch.tag = ID_CELL_SWITCH_TAG;
        cellSwitch.frame = CGRectMake( cell.frame.size.width - cellSwitch.frame.size.width - 6, 1, cellSwitch.frame.size.width, cell.frame.size.height );
        [cellSwitch addTarget:self action:@selector( onSwitchChanged: ) forControlEvents:UIControlEventValueChanged];
        [cellSwitch setOn:( filter.activeValue )];
        cellSwitch.enabled = ( ![filter.name isEqualToString:IDS_FILTER_NONE] );
        [cell.contentView addSubview:cellSwitch];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewDelegate Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:heightForRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return ( indexPath.section == iPickerViewSection && indexPath.row == 1 ) ? 160 : 33;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:heightForHeaderInSection:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:viewForHeaderInSection:                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* headerView = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, tableView.bounds.size.width, 30 ) ];
    headerView.text = [NSString stringWithFormat:@"   %@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), section + 1];
    headerView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    headerView.backgroundColor = Rgb2UIColor( 245, 200, 35 );
    headerView.textColor = [UIColor whiteColor];
    return headerView;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:didSelectRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if( indexPath.row == 1 ) return;
    
    BOOL bOtherSectionSelected = ( indexPath.section != iPickerViewSection );
    
    [tableView beginUpdates];
    if( iPickerViewSection != -1 )
    {
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:iPickerViewSection];
        [tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:( bOtherSectionSelected ) ? UITableViewRowAnimationNone : UITableViewRowAnimationTop];
        idx = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
        UITableViewCell* goneCell = [tableView cellForRowAtIndexPath:idx];
        goneCell.imageView.image = [UIImage imageNamed:@"ArrowDown.png"];
    }
    
    if( bOtherSectionSelected )
    {
        iPickerViewSection = indexPath.section;
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationTop];
        UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.imageView.image = [UIImage imageNamed:@"ArrowUp.png"];
        
        int pickerRow = [filtersArray indexOfObject:selectedCell.textLabel.text];
        NSString* filterName = [filtersArray objectAtIndex:pickerRow];
        JMFCameraIOS_FilterTVPickerCell* pickerCell = (JMFCameraIOS_FilterTVPickerCell*)[tableView cellForRowAtIndexPath:idx];
        [pickerCell.pickerView selectRow:pickerRow inComponent:0 animated:YES];
    }
    else iPickerViewSection = -1;
    
    [tableView endUpdates];
    
    if( bOtherSectionSelected )
    {
        NSIndexPath* idx = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
        [tableView scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self enableButtons];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:commitEditingStyle:forRowAtIndexPath:                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iSection = indexPath.section;
    int iRow = indexPath.row;
    iSectionToDelete = indexPath.section;
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        [self.model.context deleteObject:filter];
//      [self.model saveWithErrorBlock:nil];
    }
}

#pragma mark - UIPickerViewDataSource Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIPickerViewDataSource Methods                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfComponentsInPickerView:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:numberOfRowsInComponent:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return filtersArray.count;
}

#pragma mark - UIPickerViewDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIPickerViewDelegate Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:titleForRow:forComponent:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [filtersArray objectAtIndex:row];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:didSelectRow:inComponent:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
    UITableViewCell* cell = [self.iboFilterTable cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [filtersArray objectAtIndex:row];
    
    JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:iPickerViewSection inSection:0]];
    filter.name = [filtersArray objectAtIndex:row];
    
    UISwitch* cellSwitch = (UISwitch*)[cell viewWithTag:ID_CELL_SWITCH_TAG];
    cellSwitch.enabled = [filter isValidFilter];
    if( ![filter isValidFilter] ) [cellSwitch setOn:NO animated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:viewForRow:forComponent:reusingView:                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if( !label ) label = [[UILabel alloc]init];
    
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [filtersArray objectAtIndex:row];
    
    return label;
}

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  enableButtons                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)enableButtons
{
    int count = [[fetchedResultsController fetchedObjects]count];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setEnabled:( iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:( count > 0 && iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:( bModified && iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:( bModified && iPickerViewSection == -1 )];
    self.navigationItem.rightBarButtonItem.enabled = ( iPickerViewSection == -1 );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  addFilter:                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)addFilter:(id)sender
{
    JMFFilter* filter = [JMFFilter filterWithName:IDS_FILTER_NONE photo:(JMFPhoto*)self.photo inContext:self.model.context];
    filter.activeValue = NO;
//  [self.model saveWithErrorBlock:nil];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCancelClicked                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onCancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onClearClicked                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onClearClicked
{
    iSectionToDelete = -2;
    for( JMFFilter* filter in [fetchedResultsController fetchedObjects] ) [self.model.context deleteObject:filter];
//  [self.model saveWithErrorBlock:nil];
    [self.iboFilterTable reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onApplyClicked                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onApplyClicked
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSaveClicked                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onSaveClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSwitchChanged:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onSwitchChanged:(id)sender
{
    UISwitch* cellSwitch = (UISwitch*)sender;
    NSIndexPath* indexPath = [JMFUtility indexPathForCellSubview:cellSwitch inTableView:self.iboFilterTable];
    if( indexPath != nil )
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        filter.activeValue = cellSwitch.on;
//      [self.model saveWithErrorBlock:nil];
   }
}

@end
