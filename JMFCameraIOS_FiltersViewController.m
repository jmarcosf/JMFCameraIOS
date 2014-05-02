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
#import "JMFCameraIOS_ShowViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_FILTERTV_NORMAL_CELL_IDENTIFIER         @"FilterTVNormalCellIdentifier"
#define IDS_FILTERTV_PICKER_CELL_IDENTIFIER         @"FilterTVPickerCellIdentifier"
#define IDS_NO_IMAGE_FILE                           @"NoImage.jpg"

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
    BOOL                        bModified;
    BOOL                        bReloadData;
    BOOL                        bNoFilteredImage;
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
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image inModel:(JMFCoreDataStack*)model
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
    [[self.model.context undoManager] beginUndoGrouping];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector( addFilter: )];
    self.navigationItem.hidesBackButton = YES;
    self.title = NSLocalizedString( @"IDS_FILTERS", nil );
    bModified = bReloadData = NO;
    iPickerViewSection = -1;
    
    self.iboActivityIndicator.layer.zPosition = 100;
    if( self.image == nil ) self.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboSourceImage.image = self.image;
    bNoFilteredImage = ( self.photo.filteredImageUrl == nil || [self.photo.filteredImageUrl isEqualToString:@""] );
    self.iboTargetImage.image = ( bNoFilteredImage ) ? [UIImage imageNamed:IDS_NO_IMAGE_FILE] : [UIImage imageWithContentsOfFile:self.photo.filteredImageUrl];
    
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setTitle:NSLocalizedString( @"IDS_CANCEL", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setTitle:NSLocalizedString( @"IDS_CLEAR", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setTitle:NSLocalizedString( @"IDS_APPLY", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setTitle:NSLocalizedString( @"IDS_SAVE",  nil )];
    
    //TableView
    [self.iboFilterTable registerNib:[UINib nibWithNibName:@"JMFCameraIOS_FilterTVCell" bundle:nil] forCellReuseIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER];
    [self.iboFilterTable registerClass:[JMFCameraIOS_FilterTVPickerCell class] forCellReuseIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER];
    self.iboFilterTable.sectionHeaderHeight = 2.0;
    self.iboFilterTable.sectionFooterHeight = 20.0;
    self.iboFilterTable.delegate = self;
    self.iboFilterTable.dataSource = self;
    
    //Filters Array. Remove those CIFilters not supporting kCIInputImageKey porperty
    filtersArray = [[CIFilter filterNamesInCategories:nil]mutableCopy];
    NSMutableIndexSet* invalidFilters = [[NSMutableIndexSet alloc]init];
    for( int i = 0; i < filtersArray.count; i++ )
    {
        CIFilter* ciFilter = [CIFilter filterWithName:[filtersArray objectAtIndex:i]];
        if( [[ciFilter attributes] objectForKey:kCIInputImageKey] == nil ) [invalidFilters addIndex:i];
    }
    [filtersArray removeObjectsAtIndexes:invalidFilters];
    [filtersArray insertObject:IDS_FILTER_NONE atIndex:0];

    //Query
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[JMFFilter entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.creationDate ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.model.context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    fetchedResultsController.delegate = self;
    NSError *error;
    [fetchedResultsController performFetch:&error];
    if( error && COREDATA_DEBUG ) NSLog( @"Fetch Filters error: %@", error );
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
    self.iboActivityIndicator.hidden = YES;
    [self.iboActivityIndicator stopAnimating];
    
    [self enableButtons];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewDidAppear:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewWillDisappear                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - UIResponder Override Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIResponder Override Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  canBecomeFirstResponder                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  motionEnded:withEvent:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    if( motion == UIEventSubtypeMotionShake )
    {
        [self onClearClicked];
    }
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
    bReloadData = NO;
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
    if( type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeDelete ) bReloadData = YES;
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
    bModified = YES;
    if( bReloadData ) [self.iboFilterTable reloadData];
    bReloadData = NO;
    [self enableButtons];
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
    long iCount = [[fetchedResultsController fetchedObjects]count];
    if( iCount <= 0 ) self.iboTargetImage.image = [UIImage imageNamed:IDS_NO_IMAGE_FILE];
    return iCount;
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
    return [NSString stringWithFormat:@"%@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), (int)( section + 1 )];
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
    if( iPickerViewSection != -1 && indexPath.section == iPickerViewSection && indexPath.row == 1 )
    {
        JMFCameraIOS_FilterTVPickerCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.imageView.image = nil;
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
        cell.pickerView.showsSelectionIndicator = YES;
    
        JMFCameraIOS_FilterTVCell* selectedCell = (JMFCameraIOS_FilterTVCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        long pickerRow = [filtersArray indexOfObject:selectedCell.iboNameLabel.text];
        [cell.pickerView selectRow:pickerRow inComponent:0 animated:YES];

        return cell;
    }
    else
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        JMFCameraIOS_FilterTVCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.iboImageView.image = [UIImage imageNamed:@"ArrowDown.png"];
        cell.iboNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.iboNameLabel.text = filter.name;
        cell.iboActiveSwitch.enabled = [filter isValidFilter];
        cell.iboActiveSwitch.on = [filter isActive] && [filter isValidFilter];
        cell.indexPath = indexPath;
        cell.delegate = self;
        
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
    headerView.text = [NSString stringWithFormat:@"   %@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), (int)(section + 1)];
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
        JMFCameraIOS_FilterTVCell* goneCell = (JMFCameraIOS_FilterTVCell*)[tableView cellForRowAtIndexPath:idx];
        goneCell.iboImageView.image = [UIImage imageNamed:@"ArrowDown.png"];
    }
    
    if( bOtherSectionSelected )
    {
        iPickerViewSection = indexPath.section;
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationTop];
        JMFCameraIOS_FilterTVCell* selectedCell = (JMFCameraIOS_FilterTVCell*)[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.iboImageView.image = [UIImage imageNamed:@"ArrowUp.png"];
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
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        [self.model.context deleteObject:filter];
        [self.iboFilterTable reloadData];
    }
}

#pragma mark - JMFCameraIOS_FilterTVCellDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterTVCellDelegate Methods                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  filterCell:forIndexPath:didChangeState:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)filterCell:(JMFCameraIOS_FilterTVCell *)filterCell forIndexPath:(NSIndexPath *)indexPath didChangeState:(BOOL)newState
{
    JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    filter.active = [NSNumber numberWithBool:newState];
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
    JMFCameraIOS_FilterTVCell* cell = (JMFCameraIOS_FilterTVCell*)[self.iboFilterTable cellForRowAtIndexPath:indexPath];
    cell.iboNameLabel.text = [filtersArray objectAtIndex:row];
    
    JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:iPickerViewSection inSection:0]];
    filter.name = [filtersArray objectAtIndex:row];

    cell.iboActiveSwitch.enabled = [filter isValidFilter];
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
    long count = [[fetchedResultsController fetchedObjects]count];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setEnabled:( iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:( count > 0 && iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:( bModified && iPickerViewSection == -1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:( bModified && iPickerViewSection == -1 )];
    self.navigationItem.rightBarButtonItem.enabled = ( iPickerViewSection == -1 );
    if( count == 0 ) bNoFilteredImage = YES;
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
    [JMFFilter filterWithName:IDS_FILTER_NONE photo:(JMFPhoto*)self.photo inContext:self.model.context];
    [self.iboFilterTable reloadData];
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
    [[self.model.context undoManager] endUndoGrouping];
    [[self.model.context undoManager] undo];
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
    for( JMFFilter* filter in [fetchedResultsController fetchedObjects] ) [self.model.context deleteObject:filter];
    [self.iboFilterTable reloadData];
    self.iboTargetImage.image = [UIImage imageNamed:IDS_NO_IMAGE_FILE];
    bNoFilteredImage = YES;
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
    self.iboActivityIndicator.hidden = NO;
    [self.iboActivityIndicator startAnimating];

    if( [[fetchedResultsController fetchedObjects]count] == 0 ) bNoFilteredImage = YES;
    
    CIContext* context = [CIContext contextWithOptions:nil];
    CIImage* ciImage = [CIImage imageWithCGImage:self.iboSourceImage.image.CGImage];
    
    dispatch_queue_t filterQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 );
    dispatch_async( filterQueue, ^
    {
        CIImage* resultImage = ciImage;
        for( JMFFilter* filter in [fetchedResultsController fetchedObjects] )
        {
            if( filter.isActive && filter.isValidFilter )
            {
                if( [filter isValidCIFilter] )
                {
                    [filter.ciFilter setDefaults];
                    [filter.ciFilter setValue:resultImage forKey:kCIInputImageKey];
                    if( [[filter.ciFilter attributes] objectForKey:kCIInputIntensityKey] != nil )
                    {
                        [filter.ciFilter setValue:@0.7f forKey:kCIInputIntensityKey];
                    }
                    resultImage = [filter.ciFilter valueForKey:kCIOutputImageKey];
                }
            }
        }
        CGImageRef cgiImage = [context createCGImage:resultImage fromRect:[resultImage extent]];

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async( mainQueue, ^
        {
            self.iboTargetImage.image = [UIImage imageWithCGImage:cgiImage];
            bModified = YES;
            self.iboActivityIndicator.hidden = YES;
            [self.iboActivityIndicator stopAnimating];
        });
    });
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
    [self.photo saveFilteredImage:self.iboTargetImage.image andTumbnail:nil];
    [[self.model.context undoManager] endUndoGrouping];
    [[self.model.context undoManager] setActionName:@"Filter edit"];
    [self.model saveWithErrorBlock:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIResponder Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIResponder Methods                                                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  touchesEnded:withEvent:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIImage* image = nil;
    UITouch* touch = [touches anyObject];
    
    if( touch.view == self.iboSourceImage )      image = self.iboSourceImage.image;
    else if( touch.view == self.iboTargetImage ) image = ( bNoFilteredImage ) ? nil : self.iboTargetImage.image;
    if( image != nil )
    {
        JMFCameraIOS_ShowViewController* showVC = [[JMFCameraIOS_ShowViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

@end
