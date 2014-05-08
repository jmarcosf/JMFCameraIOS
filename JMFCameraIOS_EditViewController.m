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
#import <Social/Social.h>
#import "JMFCameraIOS_EditViewController.h"
#import "JMFCameraIOS_EditTVDataCell.h"
#import "JMFCameraIOS_EditTVGeoLocationCell.h"
#import "JMFCameraIOS_FaceRecViewController.h"
#import "JMFCameraIOS_FiltersViewController.h"
#import "JMFCameraIOS_ShowViewController.h"
#import "JMFCameraIOS_MapViewController.h"
#import "JMFFace.h"
#import "JMFFilter.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_EDITTV_NORMAL_CELL_IDENTIFIER       @"EditTVNormalCellIdentifier"
#define IDS_EDITTV_NORMAL_CELL_XIBNAME          @"JMFCameraIOS_EditTVDataCell"
#define IDS_EDITTV_GEOLOCATION_CELL_IDENTIFIER  @"EditTVGeoLocationCellIdentifier"
#define IDS_EDITTV_GEOLOCATION_CELL_XIBNAME     @"JMFCameraIOS_EditTVGeoLocationCell"

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
    NSArray*                        headerStrings;
    NSArray*                        metadataTitleStrings;
    NSArray*                        metadataValues;
    NSArray*                        locationTitleStrings;
    NSArray*                        locationValues;
    NSFetchedResultsController*     faceResultsController;
    NSFetchedResultsController*     filtersResultsController;
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

    metadataValues = @[[self.photo sourceToString], self.photo.colorModel, self.photo.colorsPerPixel,
                       [self.photo orientationToString], self.photo.pixelHeight, self.photo.pixelWidth];
    locationValues = @[self.photo.longitude, self.photo.latitude, self.photo.altitude, self.photo.geoLocation];
    
    self.iboSourceImageView.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboFullScreenLabel.text = NSLocalizedString( @"IDS_FULL_SCREEN_MESSAGE", nil );

    self.iboNameTitle.text     = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_NAME",     nil )];
    self.iboCreatedTitle.text  = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_CREATED",  nil )];
    self.iboModifiedTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_MODIFIED", nil )];
    self.iboNameValue.text     = self.photo.name;
    self.iboCreatedValue.text  = [JMFUtility formattedStringFromDate:self.photo.creationDate withFormat:@"IDS_DATETIME_FORMAT"];
    self.iboModifiedValue.text = [JMFUtility formattedStringFromDate:self.photo.modificationDate withFormat:@"IDS_DATETIME_FORMAT"];
    self.iboMapPoint.hidden = ( [self.photo.longitude doubleValue] == 0 && [self.photo.latitude doubleValue] == 0 );

    //TableView
    [self.iboTableView registerNib:[UINib nibWithNibName:IDS_EDITTV_NORMAL_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_EDITTV_NORMAL_CELL_IDENTIFIER];
    [self.iboTableView registerNib:[UINib nibWithNibName:IDS_EDITTV_GEOLOCATION_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_EDITTV_GEOLOCATION_CELL_IDENTIFIER];
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
    
    //Faces Query
    faceResultsController = nil;    //Reset contents
    NSFetchRequest* facesRequest = [NSFetchRequest fetchRequestWithEntityName:[JMFFace entityName]];
    facesRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    facesRequest.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    faceResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:facesRequest
                                                                managedObjectContext:self.model.context
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:nil];
    NSError *facesError;
    [faceResultsController performFetch:&facesError];
    if( facesError && COREDATA_DEBUG ) NSLog( @"Fetch Faces error: %@", facesError );
    
    //Filters Query
    filtersResultsController = nil;    //Reset contents
    NSFetchRequest* filtersRequest = [NSFetchRequest fetchRequestWithEntityName:[JMFFilter entityName]];
    filtersRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    filtersRequest.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    filtersResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:filtersRequest
                                                                managedObjectContext:self.model.context
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:nil];
    NSError *filtersError;
    [filtersResultsController performFetch:&filtersError];
    if( filtersError && COREDATA_DEBUG ) NSLog( @"Fetch Filters error: %@", filtersError );
    
    [self.iboTableView reloadData];
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
    long rows = 0;
    if( section == SECTION_METADATA ) rows = 6;
    else if( section == SECTION_LOCATION ) rows = 4;
    else if( section == SECTION_FACE_DETECTION ) rows = [[faceResultsController fetchedObjects]count];
    else if( section == SECTION_FILTERS ) rows = [[filtersResultsController fetchedObjects]count];
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
    UITableViewCell* cell = nil;
    
    if( indexPath.section == SECTION_LOCATION && indexPath.row == 3 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:IDS_EDITTV_GEOLOCATION_CELL_IDENTIFIER forIndexPath:indexPath];
        ( (JMFCameraIOS_EditTVGeoLocationCell*)cell ).iboDataTitle.text = nil;
        ( (JMFCameraIOS_EditTVGeoLocationCell*)cell ).iboDataValue.text = nil;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:IDS_EDITTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.text = nil;
        ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataValue.text = nil;
    }
    
    switch( indexPath.section )
    {
        case SECTION_METADATA:
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.text = NSLocalizedString( [metadataTitleStrings objectAtIndex:indexPath.row], nil );
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataValue.text = [[metadataValues objectAtIndex:indexPath.row] description];
            break;
            
        case SECTION_LOCATION:
            ( (JMFCameraIOS_EditTVGeoLocationCell*)cell ).iboDataTitle.text = NSLocalizedString( [locationTitleStrings objectAtIndex:indexPath.row], nil );
            ( (JMFCameraIOS_EditTVGeoLocationCell*)cell ).iboDataValue.text = [[locationValues objectAtIndex:indexPath.row] description];
            break;
            
        case SECTION_FACE_DETECTION:
        {
            JMFFace* face = [faceResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.text = face.name;
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataValue.text = face.faceRect;
            break;
        }

        case SECTION_FILTERS:
        {
            JMFFilter* filter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.text = filter.name;
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataValue.text = [[NSLocalizedString( @"IDS_ACTIVE", nil ) stringByAppendingString:@": "]stringByAppendingString:[filter activeToString]];
            CGRect Rect = ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.frame;
            ( (JMFCameraIOS_EditTVDataCell*)cell ).iboDataTitle.frame = CGRectMake( Rect.origin.x, Rect.origin.y, Rect.size.width + 85, Rect.size.height );
            break;
        }
            
        default:
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
    return ( indexPath.section == 1 && indexPath.row == 3 ) ? 75 : 30;
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
    headerView.text = [NSString stringWithFormat:@"  %@", NSLocalizedString( [headerStrings objectAtIndex:section], nil )];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return ( indexPath.section == SECTION_FACE_DETECTION || indexPath.section == SECTION_FILTERS );
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
        if( indexPath.section == SECTION_FACE_DETECTION )
        {
            JMFFace* face = [faceResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
            [self.model.context deleteObject:face];
            [self.model saveWithErrorBlock:nil];
            [faceResultsController performFetch:nil];
            [tableView reloadData];
        }
        else if( indexPath.section == SECTION_FILTERS )
        {
            JMFFilter* filter = [filtersResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
            [filter deleteProperties];
            [self.model.context deleteObject:filter];
            [self.model saveWithErrorBlock:nil];
            [filtersResultsController performFetch:nil];
            [tableView reloadData];
        }
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
    NSString* IDS_APP_NAME               = NSLocalizedString( @"IDS_APP_NAME", nil );
    NSString* IDS_OK                     = NSLocalizedString( @"IDS_OK", nil );
    NSString* IDS_SOCIAL_DEFAULT_MESSAGE = NSLocalizedString( @"IDS_SOCIAL_DEFAULT_MESSAGE", nil );
    NSString* IDS_SOCIAL_MESSAGE_SENT_OK = NSLocalizedString( @"IDS_SOCIAL_MESSAGE_SENT_OK", nil );

    UIActivityViewController* activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[IDS_SOCIAL_DEFAULT_MESSAGE, @"", self.iboSourceImageView.image]applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    activityVC.completionHandler = ^( NSString* activityType, BOOL completed )
    {
        if( completed )
        {
            [[[UIAlertView alloc]initWithTitle:IDS_APP_NAME message:IDS_SOCIAL_MESSAGE_SENT_OK delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles: nil]show];
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];

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
    JMFCameraIOS_FaceRecViewController* faceRecVC = [[JMFCameraIOS_FaceRecViewController alloc]
                                                     initWithPhoto:self.photo
                                                     andImage:self.iboSourceImageView.image
                                                     inModel:self.model];
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
    JMFCameraIOS_FiltersViewController* filtersVC = [[JMFCameraIOS_FiltersViewController alloc]
                                                    initWithPhoto:self.photo
                                                    andImage:self.iboSourceImageView.image
                                                    inModel:self.model];
    [self.navigationController pushViewController:filtersVC animated:YES];
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
    else if( touch.view == self.iboMapPoint )
    {
        JMFCameraIOS_MapViewController* mapVC = [[JMFCameraIOS_MapViewController alloc]initWithLongitude:self.photo.longitude
                                                                                                latitude:self.photo.latitude
                                                                                          andGeoPosition:self.photo.geoLocation];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

@end