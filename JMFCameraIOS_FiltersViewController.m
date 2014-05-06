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
#import "JMFCameraIOS_FilterPropertyTVCell.h"
#import <objc/runtime.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_FILTERTV_NORMAL_CELL_IDENTIFIER         @"FilterTVNormalCellIdentifier"
#define IDS_FILTERTV_PICKER_CELL_IDENTIFIER         @"FilterTVPickerCellIdentifier"
#define IDS_PROPERTYTV_NORMAL_CELL_IDENTIFIER       @"PropertyTVNormalCellIdentifier"
#define IDS_PROPERTYTV_NORMAL_CELL_XIBNAME          @"JMFCameraIOS_FilterPropertyTVCell"
#define IDS_NO_IMAGE_FILE                           @"NoImage.jpg"

#define IDC_UITOOLBAR_BUTTON_CANCEL_INDEX           0
#define IDC_UITOOLBAR_BUTTON_CLEAR_INDEX            1
#define IDC_UITOOLBAR_BUTTON_APPLY_INDEX            2
#define IDC_UITOOLBAR_BUTTON_SAVE_INDEX             3

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Associative Reference Key to JMFFilter object for Property TableView   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
const void *objectTagKey = "JMFFilterObject";

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
    NSArray*                    filterProperties;
    long                        iPickerViewSection;
    BOOL                        bModified;
    BOOL                        bReloadData;
    BOOL                        bNoFilteredImage;
    UIImage*                    targetImage;
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
    targetImage = ( self.photo.filteredImageUrl == nil || [self.photo.filteredImageUrl isEqualToString:@""] )
                  ? nil : [UIImage imageWithContentsOfFile:self.photo.filteredImageUrl];
    
    [self setupFilterList];
    
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setTitle:NSLocalizedString( @"IDS_CANCEL", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setTitle:NSLocalizedString( @"IDS_CLEAR", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setTitle:NSLocalizedString( @"IDS_APPLY", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setTitle:NSLocalizedString( @"IDS_SAVE",  nil )];
    
    //Filter Table
    [self.iboFilterTable registerNib:[UINib nibWithNibName:@"JMFCameraIOS_FilterTVCell" bundle:nil] forCellReuseIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER];
    [self.iboFilterTable registerClass:[JMFCameraIOS_FilterTVPickerCell class] forCellReuseIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER];
    self.iboFilterTable.sectionHeaderHeight = 2.0;
    self.iboFilterTable.sectionFooterHeight = 20.0;
    self.iboFilterTable.delegate = self;
    self.iboFilterTable.dataSource = self;
    
    //Property Table
    CGRect rect = CGRectMake(self.iboFilterTable.frame.origin.x, self.iboFilterTable.frame.origin.y, self.iboFilterTable.frame.size.width, 184 );
    self.iboPropertyTable = [[UITableView alloc]initWithFrame:rect style:self.iboFilterTable.style];
    [self.iboPropertyTable registerNib:[UINib nibWithNibName:IDS_PROPERTYTV_NORMAL_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_PROPERTYTV_NORMAL_CELL_IDENTIFIER];
    self.iboPropertyTable.sectionHeaderHeight = 2.0;
    self.iboPropertyTable.sectionFooterHeight = 20.0;
    self.iboPropertyTable.delegate = self;
    self.iboPropertyTable.dataSource = self;
    self.iboPropertyTable.hidden = YES;
    self.iboPropertyTable.tag = -1;
    [[self.iboFilterTable superview]addSubview:self.iboPropertyTable];
    
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
    
    [self setTargetImage];
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
    return (tableView == self.iboFilterTable ) ? [[fetchedResultsController fetchedObjects]count] : 1;
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
    if( tableView == self.iboPropertyTable )
    {
        JMFFilter* filter = (JMFFilter*)objc_getAssociatedObject( self.iboPropertyTable, objectTagKey );
        return [NSString stringWithFormat:@"%@ - %@", NSLocalizedString( @"IDS_FILTER", nil ), filter ];
    }
    else return [NSString stringWithFormat:@"%@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), (int)( section + 1 )];
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
    if( tableView == self.iboPropertyTable ) return filterProperties.count;
    else return ( iPickerViewSection != -1 && section == iPickerViewSection ) ? 2 : 1;
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
    if( tableView == self.iboPropertyTable )
    {
        JMFCameraIOS_FilterPropertyTVCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_PROPERTYTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.iboPropertyName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.iboPropertyName.text = [filterProperties objectAtIndex:indexPath.row];
        cell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", 0.0f ];

        return cell;
    }

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
        [cell.iboInfoButton setImage:[UIImage imageNamed:@"Data.png"]forState:UIControlStateNormal];
        cell.iboNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.iboNameLabel.text = filter.name;
        cell.iboActiveSwitch.enabled = cell.iboInfoButton.enabled = [filter isValidFilter];
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
    if( tableView == self.iboPropertyTable ) return 40;
    else return ( indexPath.section == iPickerViewSection && indexPath.row == 1 ) ? 160 : 33;
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
    NSString* headerTitle;
    if( tableView == self.iboPropertyTable )
    {
        if( self.iboPropertyTable.hidden == NO ) self.title = [NSString stringWithFormat:@"%@ %d", NSLocalizedString( @"IDS_FILTER", nil ), self.iboPropertyTable.tag];
        JMFFilter* filter = (JMFFilter*)objc_getAssociatedObject( self.iboPropertyTable, objectTagKey );
        headerTitle = [NSString stringWithFormat:@" %@", filter.name];
        
        UIView* headerContainer = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, tableView.bounds.size.width, 30 )];
        
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, headerContainer.frame.size.width - 60, headerContainer.frame.size.height ) ];
        headerLabel.text = headerTitle;
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        headerLabel.backgroundColor = Rgb2UIColor( 245, 200, 35 );
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.minimumScaleFactor = 10.0;
        
        UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [doneButton addTarget:self action:@selector( onDoneClicked: ) forControlEvents:UIControlEventTouchUpInside];
        doneButton.frame = CGRectMake( headerContainer.frame.size.width - 60, 0, 60, 30 );
        [doneButton setTitle:NSLocalizedString( @"IDS_DONE", nil ) forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        doneButton.backgroundColor = Rgb2UIColor( 245, 200, 35 );
        doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [headerContainer addSubview:headerLabel];
        [headerContainer addSubview:doneButton];
        return headerContainer;
    }
    else
    {
        headerTitle = [NSString stringWithFormat:@"   %@ %d", NSLocalizedString( @"IDS_FILTER", nil ), (int)(section + 1)];
        UILabel* headerView = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, tableView.bounds.size.width, 30 ) ];
        headerView.text = headerTitle;
        headerView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        headerView.backgroundColor = Rgb2UIColor( 245, 200, 35 );
        headerView.textColor = [UIColor whiteColor];
        return headerView;
    }
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
    if( tableView == self.iboPropertyTable )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
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
/*  tableView:canEditRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ( tableView != self.iboPropertyTable );
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
    if( tableView == self.iboPropertyTable ) return;
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        [self.model.context deleteObject:filter];
        [self.iboFilterTable reloadData];
        [self enableButtons];
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

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  filterCell:forIndexPath:didChangeState:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)filterCell:(JMFCameraIOS_FilterTVCell *)filterCell onInfoClickedforIndexPath:(NSIndexPath *)indexPath
{
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setEnabled:NO];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:NO];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:NO];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    JMFFilter* filter = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];

//    UIViewAnimationTransition animationTrnasition = UIViewAnimationTransitionFlipFromLeft;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:animationTrnasition forView:iboContainer cache:YES];
    objc_setAssociatedObject( self.iboPropertyTable, objectTagKey, filter, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    self.iboPropertyTable.tag = ( indexPath.section + 1 );
    self.iboFilterTable.hidden = YES;
    self.iboPropertyTable.hidden = NO;
//    [UIView commitAnimations];
    [self.iboPropertyTable reloadData];
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

    cell.iboActiveSwitch.enabled = cell.iboInfoButton.enabled = [filter isValidFilter];
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
/*  setupFilterList                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setupFilterList
{
    //For this practice only NSNumber generic Properties al supported
    filterProperties = @[kCIInputScaleKey, kCIInputAspectRatioKey, kCIInputRadiusKey, kCIInputAngleKey, kCIInputWidthKey,
                         kCIInputSharpnessKey, kCIInputIntensityKey, kCIInputEVKey, kCIInputSaturationKey, kCIInputBrightnessKey, kCIInputContrastKey];
    
    //Filters Array. Remove those CIFilters not supporting kCIInputImageKey porperty
    filtersArray = [[CIFilter filterNamesInCategories:nil]mutableCopy];
    NSMutableIndexSet* invalidFilters = [[NSMutableIndexSet alloc]init];
    for( int i = 0; i < filtersArray.count; i++ )
    {
        CIFilter* ciFilter = [CIFilter filterWithName:[filtersArray objectAtIndex:i]];
        if( [[ciFilter attributes] objectForKey:kCIInputImageKey] == nil ) [invalidFilters addIndex:i];
    }
    [filtersArray removeObjectsAtIndexes:invalidFilters];
    
    //Filters Array. Remove those CIFilters not supporting any of default filter properties
    [invalidFilters removeAllIndexes];;
    for( int i = 0; i < filtersArray.count; i++ )
    {
        bool bFilterOK = NO;
        CIFilter* ciFilter = [CIFilter filterWithName:[filtersArray objectAtIndex:i]];
        for( NSString* property in filterProperties )
        {
            if( [[ciFilter attributes] objectForKey:property] != nil ) { bFilterOK = YES; break; }
        }
        if( !bFilterOK )[invalidFilters addIndex:i];
    }
    [filtersArray removeObjectsAtIndexes:invalidFilters];
    
    //Inser default Filter
    [filtersArray insertObject:IDS_FILTER_NONE atIndex:0];
}

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
    bModified = YES;
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
    targetImage = nil;
    [self setTargetImage];
    
    dispatch_queue_t filterQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 );
    dispatch_async( filterQueue, ^
    {
        CIContext* context = [CIContext contextWithOptions:nil];
        CIImage* resultImage = [CIImage imageWithCGImage:self.iboSourceImage.image.CGImage];
        for( JMFFilter* filter in [fetchedResultsController fetchedObjects] )
        {
            CIFilter* ciFilter = [CIFilter filterWithName:filter.name];
            if( [filter isActive] && [filter isValidFilter] )
            {
                [ciFilter setDefaults];
                [ciFilter setValue:resultImage forKey:kCIInputImageKey];
                if( [[ciFilter attributes] objectForKey:kCIInputIntensityKey] != nil )
                {
                    [ciFilter setValue:@0.7f forKey:kCIInputIntensityKey];
                }
                resultImage = [ciFilter valueForKey:kCIOutputImageKey];
                [ciFilter setValue:nil forKey:kCIInputImageKey];
            }
        }
        targetImage = [UIImage imageWithCGImage:[context createCGImage:resultImage fromRect:[resultImage extent]]];

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async( mainQueue, ^
        {
            bModified = YES;
            [self setTargetImage];
            [self enableButtons];
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
    if( bNoFilteredImage ) self.iboTargetImage.image = nil;
    [self.photo saveFilteredImage:self.iboTargetImage.image andTumbnail:nil];
    [[self.model.context undoManager] endUndoGrouping];
    [[self.model.context undoManager] setActionName:@"Filter edit"];
    [self.model saveWithErrorBlock:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDoneClicked:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onDoneClicked:(id)sender
{
    self.title = NSLocalizedString( @"IDS_FILTERS", nil );
    objc_setAssociatedObject( self.iboPropertyTable, objectTagKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    self.iboPropertyTable.tag = -1;
    self.iboFilterTable.hidden = NO;
    self.iboPropertyTable.hidden = YES;
    [self.iboFilterTable reloadData];
    [self enableButtons];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setTargetImage                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setTargetImage
{
    bNoFilteredImage = YES;
    for( JMFFilter* filter in [fetchedResultsController fetchedObjects] )
    {
        if( filter.isActive ) { bNoFilteredImage = NO; break; }
    }
    self.iboTargetImage.image = ( bNoFilteredImage || targetImage == nil ) ? [UIImage imageNamed:IDS_NO_IMAGE_FILE] : targetImage;
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
