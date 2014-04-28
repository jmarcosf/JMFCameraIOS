/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_EditViewController.m                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Edit View Controller Class implementation file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_EditViewController.h"
#import "JMFCameraIOS_EditTVDataCell.h"
#import "JMFCameraIOS_FaceRecViewController.h"
#import "JMFCameraIOS_FiltersViewController.h"
#import "JMFCameraIOS_ShowViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_EDITTV_NORMAL_CELL_IDENTIFIER       @"EditTVNormalCellIdentifier"
#define IDS_EDITTV_NORMAL_CELL_XIBNAME          @"JMFCameraIOS_EditTVDataCell"

#define IDC_UITOOLBAR_BUTTON_SHARE_INDEX        0
#define IDC_UITOOLBAR_BUTTON_FACEDET_INDEX      1
#define IDC_UITOOLBAR_BUTTON_FILTERS_INDEX      2

#define SECTION_METADATA                        0
#define SECTION_LOCATION                        1
#define SECTION_FACE_DETECTION                  2
#define SECTION_FILTERS                         3

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_EditViewController ()
{
    NSArray*    headerStrings;
    NSArray*    metadataTitleStrings;
    NSArray*    metadataValues;
    NSArray*    locationTitleStrings;
    NSArray*    locationValues;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditViewController Class Implemantation                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_EditViewController

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
/*  initWithPhoto:inModel:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto *)photo inModel:(JMFCoreDataStack *)model
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.photo = photo;
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
    self.title = NSLocalizedString( @"IDS_EDIT", nil );
    
    headerStrings = @[@"IDS_METADATA", @"IDS_LOCATION", @"IDS_FACES", @"IDS_FILTERS" ];
    metadataTitleStrings = @[@"IDS_SOURCE", @"IDS_COLOR_MODEL", @"IDS_COLORS_PER_PIXEL", @"IDS_ORIENTATION", @"IDS_PIXEL_HEIGHT", @"IDS_PIXEL_WIDTH" ];
    locationTitleStrings = @[@"IDS_LONGITUDE", @"IDS_LATITUDE", @"IDS_ALTITUDE", @"IDS_GEOLOCATION" ];

    metadataValues = @[[self.photo sourceFromNumber:self.photo.source], self.photo.colorModel, self.photo.colorsPerPixel,
                       [self.photo orientationFromNumber:self.photo.orientation], self.photo.pixelHeight, self.photo.pixelWidth];
    locationValues = @[self.photo.longitude, self.photo.latitude, self.photo.altitude, self.photo.geoLocation];
    
    self.iboSourceImageView.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboFullScreenLabel.text = NSLocalizedString( @"IDS_FULL_SCREEN_MESSAGE", nil );

    self.iboNameTitle.text     = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_NAME",     nil )];
    self.iboCreatedTitle.text  = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_CREATED",  nil )];
    self.iboModifiedTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_MODIFIED", nil )];
    self.iboNameValue.text     = self.photo.name;
    self.iboCreatedValue.text  = [self.photo.creationDate description];
    self.iboModifiedValue.text = [self.photo.modificationDate description];

    //TableView
    [self.iboTableView registerNib:[UINib nibWithNibName:IDS_EDITTV_NORMAL_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_EDITTV_NORMAL_CELL_IDENTIFIER];
    self.iboTableView.sectionHeaderHeight = 2.0;
    self.iboTableView.sectionFooterHeight = 20.0;
    self.iboTableView.dataSource = self;
    self.iboTableView.delegate = self;
    
     //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SHARE_INDEX]      setTitle:NSLocalizedString( @"IDS_SHARE", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FACEDET_INDEX]    setTitle:NSLocalizedString( @"IDS_FACE_DETECTION", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FILTERS_INDEX]    setTitle:NSLocalizedString( @"IDS_FILTERS", nil )];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewVillAppear:                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iboSourceImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iboSourceImageView.frame = CGRectMake( 2, 2, 150, 150 );
    [self.iboSourceImageView setClipsToBounds:YES];
    self.iboFullScreenLabel.frame = CGRectMake( 2, 150, 148, 20 );
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
    return headerStrings.count;
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
    int rows = 0;
    if( section == SECTION_METADATA ) rows = 6;
    else if( section == SECTION_LOCATION ) rows = 4;
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
    JMFCameraIOS_EditTVDataCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_EDITTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];

    cell.iboDataTitle.text = nil;
    cell.iboDataValue.text = nil;
    cell.iboDataIcon.image = nil;
    
    switch( indexPath.section )
    {
        case SECTION_METADATA:
            cell.iboDataTitle.text = NSLocalizedString( [metadataTitleStrings objectAtIndex:indexPath.row], nil );
            cell.iboDataValue.text = [[metadataValues objectAtIndex:indexPath.row] description];
            break;
            
        case SECTION_LOCATION:
            cell.iboDataTitle.text = NSLocalizedString( [locationTitleStrings objectAtIndex:indexPath.row], nil );
            cell.iboDataValue.text = [[locationValues objectAtIndex:indexPath.row] description];
            break;
            
//        case SECTION_FACE_DETECTION:
//            break;
//            
//        case SECTION_FILTERS:
//            break;
            
        default:
            cell.iboDataTitle.text = [NSString stringWithFormat:@"Section %d - Row %d", indexPath.section + 1, indexPath.row + 1];
            break;
    }
    

    return cell;
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
    return 30;
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
    headerView.text = [NSString stringWithFormat:@"   %@", NSLocalizedString( [headerStrings objectAtIndex:section], nil )];
    headerView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        case IDC_UITOOLBAR_BUTTON_SHARE_INDEX:      [self onShareClicked];          break;
        case IDC_UITOOLBAR_BUTTON_FACEDET_INDEX:    [self onFaceDetectionClicked];  break;
        case IDC_UITOOLBAR_BUTTON_FILTERS_INDEX:    [self onFiltersClicked];        break;
    }
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
/*  onShareClicked                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onShareClicked
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFaceDetectionClicked                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onFaceDetectionClicked
{
    JMFCameraIOS_FaceRecViewController* faceRecVC = [[JMFCameraIOS_FaceRecViewController alloc] initWithPhoto:self.photo andImage:self.iboSourceImageView.image];
    [self.navigationController pushViewController:faceRecVC animated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFiltersClicked                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onFiltersClicked
{
//    JMFCameraIOS_FiltersViewController* filtersVC = [[JMFCameraIOS_FiltersViewController alloc] initWithImage:self.image];
//    [self.navigationController pushViewController:filtersVC animated:YES];
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
    
    if( touch.view == self.iboSourceImageView )
    {
        image = self.iboSourceImageView.image;
        JMFCameraIOS_ShowViewController* showVC = [[JMFCameraIOS_ShowViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

@end