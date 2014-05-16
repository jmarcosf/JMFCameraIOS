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

#define IDC_UITOOLBAR_BUTTON_BACK_INDEX             0

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Keyboard re-layout constants                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static const CGFloat KEYBOARD_ANIMATION_DURATION    = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION        = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION        = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT       = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT      = 162;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FiltersViewController ()
{
    NSFetchedResultsController* filtersResultsController;
    NSMutableArray*             filtersArray;
    
    NSMutableArray*             tbiaFilterMode;
    NSMutableArray*             tbiaPropertyMode;
    
    long                        iPickerViewSection;
    BOOL                        bModified;
    BOOL                        bReloadData;
    BOOL                        bFromInsert;
    BOOL                        bNoFilteredImage;
    UIImage*                    targetImage;
    UIView*                     containerView;
    int                         viewMode;
    
    CGFloat                     animatedDistance;
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
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector( onAddFilterClicked: )];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:ResString( @"IDS_MOVE" )
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( onMoveClicked: )];

    self.title = ResString( @"IDS_FILTERS" );
    bModified = bReloadData = NO;
    iPickerViewSection = -1;

    //Images
    self.iboActivityIndicator.layer.zPosition = 100;
    if( self.image == nil ) self.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboSourceImage.image = self.image;
    targetImage = ( self.photo.filteredImageUrl == nil || [self.photo.filteredImageUrl isEqualToString:@""] )
                  ? nil : [UIImage imageWithContentsOfFile:self.photo.filteredImageUrl];
    
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setTitle:ResString( @"IDS_CANCEL" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setTitle:ResString( @"IDS_CLEAR" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setTitle:ResString( @"IDS_APPLY" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setTitle:ResString( @"IDS_SAVE" )];

    //TabBarItems
    UIImage* iconBack = [UIImage imageNamed:@"Back.png"];
    UITabBarItem* tbiBackItem = [[UITabBarItem alloc]initWithTitle:ResString( @"IDS_BACK" ) image:iconBack selectedImage:iconBack];
    tbiBackItem.tag = IDC_UITOOLBAR_BUTTON_BACK_INDEX;
    tbiaFilterMode = [[[NSMutableArray alloc]initWithArray:self.iboTabBar.items] mutableCopy];
    tbiaPropertyMode = [[[NSMutableArray alloc]initWithArray:self.iboTabBar.items] mutableCopy];
    [tbiaPropertyMode replaceObjectAtIndex:IDC_UITOOLBAR_BUTTON_BACK_INDEX withObject:tbiBackItem];
    
    //TableView Container View
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.iboTabBar.frame.size.height;
    int y = self.iboSourceImage.frame.size.height + 15;
    int height = screenRect.size.height - tabBarHeight - statusBarHeight - navigationBarHeight - y;
    CGRect rect = CGRectMake( 0, y,  self.view.frame.size.width, height - 1 );
    containerView = [[UIView alloc]init];
    [self.view addSubview:containerView];
    containerView.frame = rect;
    CGRect childRect = CGRectMake( 0, 0, containerView.frame.size.width, containerView.frame.size.height );
    
    //Filter Table
    self.iboFilterTable = [[UITableView alloc]initWithFrame:childRect style:UITableViewStylePlain];
    [self.iboFilterTable registerNib:[UINib nibWithNibName:@"JMFCameraIOS_FilterTVCell" bundle:nil] forCellReuseIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER];
    [self.iboFilterTable registerClass:[JMFCameraIOS_FilterTVPickerCell class] forCellReuseIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER];
    self.iboFilterTable.sectionHeaderHeight = 2.0;
    self.iboFilterTable.sectionFooterHeight = 20.0;
    self.iboFilterTable.delegate = self;
    self.iboFilterTable.dataSource = self;
    [containerView addSubview:self.iboFilterTable];
    
    //Property Table
    self.iboPropertyTable = [[UITableView alloc]initWithFrame:childRect style:UITableViewStylePlain];
    [self.iboPropertyTable registerNib:[UINib nibWithNibName:IDS_PROPERTYTV_NORMAL_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_PROPERTYTV_NORMAL_CELL_IDENTIFIER];
    self.iboPropertyTable.sectionHeaderHeight = 2.0;
    self.iboPropertyTable.sectionFooterHeight = 20.0;
    self.iboPropertyTable.delegate = self;
    self.iboPropertyTable.dataSource = self;
    self.iboPropertyTable.hidden = YES;
    self.iboPropertyTable.tag = -1;
    [containerView addSubview:self.iboPropertyTable];
    
    //Setup Filters
    [self setupFilterList];
    
    //Query
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[JMFFilter entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFFilterAttributes.position ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    filtersResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.model.context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    filtersResultsController.delegate = self;
    NSError *error;
    [filtersResultsController performFetch:&error];
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
        case IDC_UITOOLBAR_BUTTON_CANCEL_INDEX: ( self.iboFilterTable.hidden == YES ) ? [self onBackClicked ] : [self onCancelClicked]; break;
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
    bReloadData = bFromInsert = NO;
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
    if( type == NSFetchedResultsChangeInsert ||
        type == NSFetchedResultsChangeDelete ||
        type == NSFetchedResultsChangeMove    ) bReloadData = YES;
    
    if( type == NSFetchedResultsChangeInsert ) bFromInsert = YES;
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
    if( tableView.hidden == YES ) return 0;
    else return (tableView == self.iboFilterTable ) ? [[filtersResultsController fetchedObjects]count] : 1;
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
    if( tableView.hidden == YES ) return nil;
    
    if( tableView == self.iboPropertyTable )
    {
        JMFFilter* selectedFilter = [self getSelectedFilter];
        return [NSString stringWithFormat:@"%@ - %@", ResString( @"IDS_FILTER" ), selectedFilter ];
    }
    else return [NSString stringWithFormat:@"%@ #%d", ResString( @"IDS_FILTER" ), (int)( section + 1 )];
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
    if( tableView.hidden == YES ) return 0;
    
    if( tableView == self.iboPropertyTable )
    {
        JMFFilter* selectedFilter = [self getSelectedFilter];
        return [[[selectedFilter propertiesResultsController]fetchedObjects]count];
    }
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
        JMFFilter* selectedFilter = [self getSelectedFilter];
        JMFFilterProperty* filterProperty = [[selectedFilter propertiesResultsController]objectAtIndexPath:indexPath];
        
        JMFCameraIOS_FilterPropertyTVCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_PROPERTYTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.iboPropertyName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.iboPropertyName.text = filterProperty.name;
        cell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", filterProperty.value.floatValue ];
        cell.iboPropertyValue.delegate = self;
        cell.indexPath = indexPath;
        cell.delegate = self;

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
        JMFFilter* filter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        JMFCameraIOS_FilterTVCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.iboImageView.image = [UIImage imageNamed:@"ArrowDown.png"];
        [cell.iboPropertiesButton setImage:[UIImage imageNamed:@"Data.png"]forState:UIControlStateNormal];
        cell.iboNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.iboNameLabel.text = filter.name;
        cell.iboActiveSwitch.enabled = cell.iboPropertiesButton.enabled = [filter isValidFilter];
        cell.iboActiveSwitch.on = [filter isActive] && [filter isValidFilter];
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        return cell;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:canMoveRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    return ( tableView == self.iboFilterTable );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:moveRowAtIndexPath:toIndexPath:                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    if( sourceIndexPath.section == destinationIndexPath.section ) return;
    
    JMFFilter* sourceFilter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sourceIndexPath.section inSection:0]];
    JMFFilter* targetFilter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:destinationIndexPath.section inSection:0]];
    
    NSNumber* sourcePosition = sourceFilter.position;
    NSNumber* targetPosition = targetFilter.position;
    
    sourceFilter.position = targetPosition;
    targetFilter.position = sourcePosition;

    [self onMoveClicked:self];
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
        NSIndexPath* indexPath = [[self.iboFilterTable indexPathsForSelectedRows]objectAtIndex:0];
        JMFFilter* selectedFilter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        
        self.title = [NSString stringWithFormat:@"%@ %d", ResString( @"IDS_FILTER" ), (int)indexPath.section + 1];
        headerTitle = [NSString stringWithFormat:@" %@", selectedFilter.name];
        
        UIView* headerContainer = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, tableView.bounds.size.width, 30 )];
        
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, headerContainer.frame.size.width, headerContainer.frame.size.height ) ];
        headerLabel.text = headerTitle;
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        headerLabel.backgroundColor = Rgb2UIColor( 245, 200, 35 );
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.minimumScaleFactor = 10.0;

        [headerContainer addSubview:headerLabel];
        return headerContainer;
    }
    else
    {
        headerTitle = [NSString stringWithFormat:@"   %@ %d", ResString( @"IDS_FILTER" ), (int)(section + 1)];
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
    if( tableView.hidden == YES ) return;
    
    if( tableView == self.iboPropertyTable )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    if( indexPath.row == 1 ) return;
    
    JMFFilter* selectedFilter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    BOOL bOtherSectionSelected = ( indexPath.section != iPickerViewSection );
    
    [tableView beginUpdates];
    if( iPickerViewSection != -1 )
    {
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:iPickerViewSection];
        [tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:( bOtherSectionSelected ) ? UITableViewRowAnimationNone : UITableViewRowAnimationTop];
        idx = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
        JMFCameraIOS_FilterTVCell* goneCell = (JMFCameraIOS_FilterTVCell*)[tableView cellForRowAtIndexPath:idx];
        goneCell.iboImageView.image = [UIImage imageNamed:@"ArrowDown.png"];
        [selectedFilter setNewName:goneCell.iboNameLabel.text];
        goneCell.iboPropertiesButton.enabled = goneCell.iboActiveSwitch.enabled = [selectedFilter isValidFilter];
    }
    
    if( bOtherSectionSelected )
    {
        iPickerViewSection = indexPath.section;
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationTop];
        JMFCameraIOS_FilterTVCell* selectedCell = (JMFCameraIOS_FilterTVCell*)[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.iboImageView.image = [UIImage imageNamed:@"ArrowUp.png"];
        selectedCell.iboPropertiesButton.enabled = NO;
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
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
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
        JMFFilter* filter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        [filter deleteProperties];
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
- (void)filterCell:(JMFCameraIOS_FilterTVCell*)filterCell forIndexPath:(NSIndexPath*)indexPath didChangeState:(BOOL)newState
{
    JMFFilter* filter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    filter.active = [NSNumber numberWithBool:newState];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  filterCell:onPropertiesClickedforIndexPath:                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)filterCell:(JMFCameraIOS_FilterTVCell*)filterCell onPropertiesClickedforIndexPath:(NSIndexPath*)indexPath
{
    UIViewAnimationTransition animationTrnasition = UIViewAnimationTransitionFlipFromLeft;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:animationTrnasition forView:containerView cache:YES];
    self.iboFilterTable.hidden = YES;
    self.iboPropertyTable.hidden = NO;
    [UIView commitAnimations];
    [self.iboFilterTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self enableButtons];
    self.iboTabBar.items = tbiaPropertyMode;
    [self.iboPropertyTable reloadData];
}

#pragma mark - JMFCameraIOS_FilterPropertyTVCellDelegate Methods
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
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell*)filterPropertyCell didChangeValue:(CGFloat)newValue forIndexPath:(NSIndexPath*)indexPath
{
    JMFFilter* selectedFilter = [self getSelectedFilter];
    JMFFilterProperty* filterProperty = [[selectedFilter propertiesResultsController]objectAtIndexPath:indexPath];
    
    filterProperty.value = [NSNumber numberWithFloat:newValue];
    if( filterProperty.max != nil && filterProperty.value.floatValue > filterProperty.max.floatValue )
    {
        filterProperty.value = filterProperty.max;
        filterPropertyCell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", filterProperty.value.floatValue];
    }
    else if( filterProperty.min != nil && filterProperty.value.floatValue < filterProperty.min.floatValue )
    {
        filterProperty.value = filterProperty.min;
        filterPropertyCell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", filterProperty.value.floatValue];
    }
    bModified = YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  filterCell:shouldIncrementValue:forIndexPath:                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell *)filterPropertyCell shouldIncrementValue:(CGFloat)value forIndexPath:(NSIndexPath *)indexPath
{
    JMFFilter* selectedFilter = [self getSelectedFilter];
    JMFFilterProperty* filterProperty = [[selectedFilter propertiesResultsController]objectAtIndexPath:indexPath];
    
    if( filterProperty.step == nil || filterProperty.step.floatValue == 0.0f ) value += 0.1f;
    else value += filterProperty.step.floatValue;
    
    filterProperty.value = [NSNumber numberWithFloat:value];
    if( filterProperty.max != nil && filterProperty.value.floatValue > filterProperty.max.floatValue )
    {
        filterProperty.value = filterProperty.max;
    }
    filterPropertyCell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", filterProperty.value.floatValue];
    bModified = YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  filterCell:shouldDecrementValue:forIndexPath:                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell *)filterPropertyCell shouldDecrementValue:(CGFloat)value forIndexPath:(NSIndexPath *)indexPath
{
    JMFFilter* selectedFilter = [self getSelectedFilter];
    JMFFilterProperty* filterProperty = [[selectedFilter propertiesResultsController]objectAtIndexPath:indexPath];
    
    if( filterProperty.step == nil || filterProperty.step.floatValue == 0.0f ) value -= 0.1f;
    else value -= filterProperty.step.floatValue;
    
    filterProperty.value = [NSNumber numberWithFloat:value];
    if( filterProperty.min != nil && filterProperty.value.floatValue < filterProperty.min.floatValue )
    {
        filterProperty.value = filterProperty.min;
    }
    filterPropertyCell.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", filterProperty.value.floatValue];
    bModified = YES;
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
        for( NSString* property in [FilterProperties filterProperties ] )
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
    if( self.iboFilterTable.hidden == YES )
    {
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_BACK_INDEX]   setEnabled:YES];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:NO];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:YES];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:NO];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else
    {
        long count = [[filtersResultsController fetchedObjects]count];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setEnabled:( iPickerViewSection == -1 )];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:( count > 0 && iPickerViewSection == -1 )];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:( bModified && iPickerViewSection == -1 )];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:( bModified && iPickerViewSection == -1 )];
        self.navigationItem.rightBarButtonItem.enabled = ( iPickerViewSection == -1 );
        self.navigationItem.leftBarButtonItem.enabled = ( count > 1 );
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onAddFilterClicked:                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onAddFilterClicked:(id)sender
{
    [JMFFilter filterWithName:IDS_FILTER_NONE
                        photo:(JMFPhoto*)self.photo
                     position:[[filtersResultsController fetchedObjects]count]
                    inContext:self.model.context];
    [self.iboFilterTable reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onMoveClicked:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onMoveClicked:(id)sender
{
    BOOL bEdit = ![self.iboFilterTable isEditing];
    
    if( bEdit )
    {
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setEnabled:NO];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:NO];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setEnabled:NO];
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:NO];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.title = ResString( @"IDS_CANCEL" );
    }
    else
    {
        [self enableButtons];
        self.navigationItem.leftBarButtonItem.title = ResString( @"IDS_MOVE" );
    }

    [self.iboFilterTable setEditing:bEdit animated:YES];
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
/*  onBackClicked                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onBackClicked
{
    UIViewAnimationTransition animationTrnasition = UIViewAnimationTransitionFlipFromRight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:animationTrnasition forView:containerView cache:YES];
    self.iboFilterTable.hidden = NO;
    self.iboPropertyTable.hidden = YES;
    [UIView commitAnimations];
    [self.iboFilterTable reloadData];
    self.title = ResString( @"IDS_FILTERS" );
    self.iboTabBar.items = tbiaFilterMode;
    [self enableButtons];
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
    for( JMFFilter* filter in [filtersResultsController fetchedObjects] )
    {
        [filter deleteProperties];
        [self.model.context deleteObject:filter];
    }
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
        
        for( JMFFilter* filter in [filtersResultsController fetchedObjects] )
        {
            CIFilter* ciFilter = [CIFilter filterWithName:filter.name];
            if( [filter isActive] && [filter isValidFilter] )
            {
                [ciFilter setDefaults];
                [ciFilter setValue:resultImage forKey:kCIInputImageKey];
                
                for( JMFFilterProperty* property in [filter.propertiesResultsController fetchedObjects] )
                {
                    [ciFilter setValue:property.value forKey:property.name];
                }
                resultImage = [ciFilter valueForKey:kCIOutputImageKey];
            }
        }
        
        CGImageRef cgImage = [context createCGImage:resultImage fromRect:[resultImage extent]];
        targetImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease( cgImage );

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
    [[self.model.context undoManager] setActionName:@"Filter Edit"];
    [self.model saveWithErrorBlock:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    for( JMFFilter* filter in [filtersResultsController fetchedObjects] )
    {
        if( filter.isActive ) { bNoFilteredImage = NO; break; }
    }
    self.iboTargetImage.image = ( bNoFilteredImage || targetImage == nil ) ? [UIImage imageNamed:IDS_NO_IMAGE_FILE] : targetImage;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  getSelectedFilter                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (JMFFilter*)getSelectedFilter
{
    NSIndexPath* indexPath = [[self.iboFilterTable indexPathsForSelectedRows]objectAtIndex:0];
    JMFFilter* selectedFilter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    return selectedFilter;
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

#pragma mark - UITextFieldDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITextFieldDelegate Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  textFieldDidBeginEditing:                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect   = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect        = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline        = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator      = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator    = ( MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION ) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if( heightFraction < 0.0 ) heightFraction = 0.0;
    else if( heightFraction > 1.0 ) heightFraction = 1.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    animatedDistance = ( orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown )
                       ? floor( PORTRAIT_KEYBOARD_HEIGHT * heightFraction ) : floor( LANDSCAPE_KEYBOARD_HEIGHT * heightFraction );
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  textField:shouldChangeCharactersInRange:replacementString:             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    for( int i = 0; i < string.length; i++ )
    {
        switch( [string characterAtIndex:i] )
        {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '+':
            case '-':
            case '.':
                break;
                
            default:
                return NO;
        }
    }
    return YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  textFieldDidEndEditing:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  textFieldShouldReturn:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
