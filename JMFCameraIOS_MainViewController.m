/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainViewController.m                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main View Controller Class implementation file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_MainViewController.h"
#import "JMFCameraIOS_MainCVPhotoCell.h"
#import "JMFCameraIOS_MainTVCell.h"
#import "JMFCameraIOS_AlbumViewController.h"
#import "JMFCameraIOS_EditViewController.h"
#import "JMFCameraIOS_SettingsViewController.h"
#import "JMFFlickr.h"
@import AddressBook;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_MAINCV_HEADER_CELL_IDENTIFIER           @"MainCVHeaderCellIdentifier"
#define IDS_MAINCV_PHOTO_CELL_XIBNAME               @"JMFCameraIOS_MainCVPhotoCell"
#define IDS_MAINCV_PHOTO_CELL_IDENTIFIER            @"MainCVPhotoCellIdentifier"
#define IDS_MAINTV_CELL_XIBNAME                     @"JMFCameraIOS_MainTVCell"
#define IDS_MAINTV_CELL_IDENTIFIER                  @"MainTVCellIdentifier"

#define IDC_UITOOLBAR_BUTTON_CAMERA_INDEX           0
#define IDC_UITOOLBAR_BUTTON_MODE_INDEX             1
#define IDC_UITOOLBAR_BUTTON_DELETE_INDEX           2
#define IDC_UITOOLBAR_BUTTON_FLICKR_INDEX           3
#define IDC_UITOOLBAR_BUTTON_ALBUM_INDEX            4
#define IDC_UITOOLBAR_BUTTON_SYNC_INDEX             5

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController ()
{
    NSFetchRequest*         fetchRequest;
    
    UIBarButtonItem*        iboSelectButton;
    UIView*                 iboContainer;
    UILabel*                iboEmptyAlbumLabel;
    
    NSMutableArray*         tbiaMosaicMode;
    NSMutableArray*         tbiaListMode;

    BOOL                    bMultiSelectMode;
    BOOL                    bFromCamera;
    int                     iSelectedCount;
    
    CLLocationManager*      locationManager;
    NSNumber*               currentLongitude;
    NSNumber*               currentLatitude;
    NSNumber*               currentAltitude;
    NSString*               currentGeoLocation;

    BOOL                    bSyncToFlickrEnabled;
    BOOL                    bSynchronizing;
    JMFFlickrSync*          flickrSyncTask;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Implemantation                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_MainViewController

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
/*  initWithModel:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(JMFCoreDataStack*)model
{
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JMFPhoto entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    NSFetchedResultsController* fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                             managedObjectContext:model.context
                                                                                               sectionNameKeyPath:nil
                                                                                                        cacheName:nil];

    if( self = [super initWithFetchedResultsController:fetchResultsController viewMode:JMFCoreDataViewModeMosaic] )
    {
        self.model = model;
        self.model.context.undoManager = [[NSUndoManager alloc]init];
    }
    return self;
}

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
    
    self.title = ResString( @"IDS_APP_NAME" );
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.navigationController.navigationBar.translucent = NO;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.iboTabBar.frame.size.height;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bFromCamera = bSynchronizing = NO;
    self.iboActivityIndicator.hidden = YES;
    self.iboActivityIndicator.layer.zPosition = 100;
    [self.iboActivityIndicator stopAnimating];
    
    //Navigation Bar Buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector( onSettingsClicked: )];
    bMultiSelectMode = NO;
    iboSelectButton = [[UIBarButtonItem alloc] initWithTitle:ResString( @"IDS_SELECT" )
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector( onSelectClicked:)];
    [iboSelectButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14], NSFontAttributeName,nil]forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:iboSelectButton];

    //CoreLocation
    locationManager =  [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    currentLongitude = currentLatitude = currentAltitude = nil;
    currentGeoLocation = nil;
    
    //TabBar
    self.iboTabBar.delegate = self;
    self.iboTabBar.layer.zPosition = 10;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CAMERA_INDEX] setTitle:ResString( @"IDS_CAMERA" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX]   setTitle:ResString( @"IDS_LIST_MODE" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setTitle:ResString( @"IDS_DELETE" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FLICKR_INDEX] setTitle:ResString( @"IDS_FLICKR" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_ALBUM_INDEX]  setTitle:ResString( @"IDS_ALBUM" )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SYNC_INDEX]   setTitle:ResString( @"IDS_SYNC" )];
    
    //TabBarItems
    UIImage* iconMosaicMode = [UIImage imageNamed:@"MosaicMode.png"];
    UITabBarItem* tbiMosaicMode = [[UITabBarItem alloc]initWithTitle:ResString( @"IDS_MOSAIC_MODE" ) image:iconMosaicMode selectedImage:iconMosaicMode];
    tbiMosaicMode.tag = IDC_UITOOLBAR_BUTTON_MODE_INDEX;
    tbiaMosaicMode = [[[NSMutableArray alloc]initWithArray:self.iboTabBar.items] mutableCopy];
    tbiaListMode = [[[NSMutableArray alloc]initWithArray:self.iboTabBar.items] mutableCopy];
    [tbiaListMode replaceObjectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX withObject:tbiMosaicMode];

    //Container
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect Rect = CGRectMake( 0, 0, screenRect.size.width, screenRect.size.height - statusBarHeight - navigationBarHeight - tabBarHeight );
    iboContainer = [[UIView alloc]initWithFrame:Rect];
    iboContainer.layer.zPosition = -5;
    iboContainer.clipsToBounds = YES;
    [self.view addSubview:iboContainer];

    //UILabel
    iboEmptyAlbumLabel = [[UILabel alloc]initWithFrame:Rect];
    iboEmptyAlbumLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    iboEmptyAlbumLabel.textAlignment = NSTextAlignmentCenter;
    iboEmptyAlbumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    iboEmptyAlbumLabel.numberOfLines = 10;
    iboEmptyAlbumLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    iboEmptyAlbumLabel.text = ResString( @"IDS_EMPTY_ALBUM_MESSAGE" );
    iboEmptyAlbumLabel.layer.zPosition = 5;
    [iboContainer addSubview:iboEmptyAlbumLabel];
    
    // Collection View
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:Rect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.allowsMultipleSelection = bMultiSelectMode;
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDS_MAINCV_HEADER_CELL_IDENTIFIER];
    [self.collectionView registerNib:[UINib nibWithNibName:IDS_MAINCV_PHOTO_CELL_XIBNAME bundle:nil] forCellWithReuseIdentifier:IDS_MAINCV_PHOTO_CELL_IDENTIFIER];
    self.collectionView.layer.zPosition = 4;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [iboContainer addSubview:self.collectionView];
    
    //Table View
    self.tableView = [[UITableView alloc]initWithFrame:Rect style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.allowsMultipleSelection = bMultiSelectMode;
    [self.tableView registerNib:[UINib nibWithNibName:IDS_MAINTV_CELL_XIBNAME bundle:nil] forCellReuseIdentifier:IDS_MAINTV_CELL_IDENTIFIER];
    self.tableView.layer.zPosition = 4;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [iboContainer addSubview:self.tableView];
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
    
    if( bFromCamera )
    {
        self.iboActivityIndicator.hidden = NO;
        [self.iboActivityIndicator startAnimating];
        bFromCamera = NO;
    }
    
    if( [CLLocationManager locationServicesEnabled] ) [locationManager startUpdatingLocation];
  
    //Get Sync Flag
    NSUserDefaults* appPreferences = [NSUserDefaults standardUserDefaults];
    bSyncToFlickrEnabled = [[appPreferences objectForKey:PREFERENCE_SYNC_TO_FLKR_KEY] boolValue];
    
    //Refresh fetchedResultsController when Database has been re-built
    if( self.model.bDroppedData )
    {
        [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:self.model.context
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil]];
        self.iboActivityIndicator.hidden = YES;
        [self.iboActivityIndicator stopAnimating];
        self.model.bDroppedData = NO;
    }
    [self redrawControls:NO];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewDidDisappear:                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if( [CLLocationManager locationServicesEnabled] ) [locationManager stopUpdatingLocation];
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
        case IDC_UITOOLBAR_BUTTON_CAMERA_INDEX: [self onCameraClicked];     break;
        case IDC_UITOOLBAR_BUTTON_MODE_INDEX:   [self onModeClicked];       break;
        case IDC_UITOOLBAR_BUTTON_DELETE_INDEX: [self onDeleteClicked];     break;
        case IDC_UITOOLBAR_BUTTON_FLICKR_INDEX: [self onFlickrClicked];     break;
        case IDC_UITOOLBAR_BUTTON_ALBUM_INDEX:  [self onAlbumClicked];      break;
        case IDC_UITOOLBAR_BUTTON_SYNC_INDEX:   [self onSyncClicked];       break;
    }
}

#pragma mark - CLLocationManagerDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  CLLocationManagerDelegate Methods                                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  locationManager:didUpdateLocations:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation* currentLocation = [locations lastObject];
    currentLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    currentLatitude  = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    currentAltitude  = [NSNumber numberWithDouble:currentLocation.altitude];
    
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^( NSArray* placemarks, NSError *error )
    {
         if( placemarks.count > 0 )
         {
             CLPlacemark* info = [placemarks lastObject];
             NSString* locationString = [NSString stringWithFormat:@"%@\n%@\n%@",
                                         [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressStreetKey],
                                         [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressZIPKey],
                                         [[info addressDictionary] objectForKey:(NSString*)kABPersonAddressCountryKey]];
             currentGeoLocation = locationString;
         }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIImagePickerControllerDelegate Methods                                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  imagePickerController:didFinishPickingMediaWithInfo:                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    bFromCamera = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async( queue, ^
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        JMFPhoto* newPhoto = [JMFPhoto photoWithImage:image
                                               source:JMFPhotoSourceCamera
                                            thumbnail:nil
                                            inContext:self.model.context];
        [newPhoto setLocationLongitude:currentLongitude latitude:currentLatitude altitude:currentAltitude geoLocation:currentGeoLocation];
        [self.model saveWithErrorBlock:nil];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self performFetch];
            [self reloadData];
            [self scrollToBottom];
            
            [self redrawControls:NO];
            bFromCamera = NO;
            self.iboActivityIndicator.hidden = YES;
            [self.iboActivityIndicator stopAnimating];
        });
    });
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  imagePickerControllerDidCancel:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UICollectionViewDelegateFlowLayout Methods                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:layout:sizeForItemAtIndexPath:                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake( 96, 96 );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:layout:insetForSectionAtIndex:                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 1, 6, 1, 6 );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:layout:referenceSizeForHeaderInSection:                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake( collectionView.frame.size.width, 25 );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:viewForSupplementaryElementOfKind:atIndexPath:          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if( kind == UICollectionElementKindSectionHeader )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:IDS_MAINCV_HEADER_CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];
        if( reusableView != nil )
        {
            NSArray* subViews = [reusableView subviews];
            for( UIView* subView in subViews ) [subView removeFromSuperview];
            CGRect frame = CGRectMake( 5, 0, reusableView.frame.size.width - 10, reusableView.frame.size.height );
            UILabel* header = [[UILabel alloc]initWithFrame:frame];
            long picturesCount = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
            header.text = [NSString stringWithFormat:@"%ld %@", picturesCount, ResString( @"IDS_PICTURES" )];
            [reusableView addSubview:header];
        }
    }
    return reusableView;
}

#pragma mark - UICollectionViewDataSource
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UICollectionViewDataSource Methods                                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:cellForItemAtIndexPath:                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    JMFCameraIOS_MainCVPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDS_MAINCV_PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSData*  imageData = [NSData dataWithContentsOfFile:photo.sourceThumbnailUrl];
    UIImage* image = [UIImage imageWithData:imageData];
    cell.iboPhotoImage.image = ( image != nil ) ? image : [UIImage imageNamed:@"NoImage.jpg"];
    cell.bImageOK = ( image != nil );
    cell.iboSelectedIcon.image = [UIImage imageNamed:@"GreenCheck.png"];
    cell.iboSelectedIcon.hidden = !cell.isSelected;
    cell.iboSelectedIcon.layer.zPosition = 10;
    cell.iboSyncProgress.hidden = YES;
    cell.iboSyncProgress.layer.zPosition = 10;
    cell.iboSynchronizedIcon.hidden = ![photo.uploaded boolValue];
    cell.iboSynchronizedIcon.layer.zPosition = 10;
    return cell;
}

#pragma mark - UICollectionViewDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UICollectionViewDelegate Methods                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:didSelectItemAtIndexPath:                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMFCameraIOS_MainCVPhotoCell* cell = (JMFCameraIOS_MainCVPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if( bMultiSelectMode )
    {
        if( !cell.bUploading )
        {
            iSelectedCount++;
            [self redrawControls:YES];
        }
        else [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else
    {
        cell.iboSelectedIcon.hidden = YES;
        [self editPhoto];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:didDeselectItemAtIndexPath:                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( bMultiSelectMode )
    {
        iSelectedCount--;
        [self redrawControls:YES];
    }
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
/*  titleForHeaderInSection:                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    long picturesCount = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return [NSString stringWithFormat:@"%ld %@", picturesCount, ResString( @"IDS_PICTURES" )];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:cellForRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSData*  imageData = [NSData dataWithContentsOfFile:photo.sourceThumbnailUrl];
    UIImage* image = [UIImage imageWithData:imageData];
    
    JMFCameraIOS_MainTVCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:IDS_MAINTV_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.imageView.image     = ( image != nil ) ? image : [UIImage imageNamed:@"NoImage.jpg"];
    cell.iboNameLabel.text   = photo.name;
    cell.iboSizeLabel.text   = [NSString stringWithFormat:@"%d x %d", photo.pixelWidthValue, photo.pixelHeightValue];
    cell.iboSourceTitle.text = [ResString( @"IDS_SOURCE" ) stringByAppendingString:@":"];
    cell.iboSourceValue.text = [photo sourceToString];
    cell.iboWhenTitle.text   = [ResString( @"IDS_WHEN" ) stringByAppendingString:@":"];
    cell.iboWhenValue.text   = [JMFUtility formattedStringFromDate:photo.creationDate withFormat:@"IDS_DATETIME_FORMAT"];
    cell.iboWhereTitle.text  = [ResString( @"IDS_WHERE" ) stringByAppendingString:@":"];
    cell.iboWhereValue.text  = photo.geoLocation;
    cell.iboSyncProgress.hidden = YES;
    cell.iboSyncProgress.layer.zPosition = 10;
    cell.iboSynchronizedIcon.hidden = ![photo.uploaded boolValue];
    cell.iboSynchronizedIcon.layer.zPosition = 10;
    
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
    return 85;
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
    JMFCameraIOS_MainTVCell* cell = (JMFCameraIOS_MainTVCell*)[tableView cellForRowAtIndexPath:indexPath];
    if( bMultiSelectMode )
    {
        if( !cell.bUploading )
        {
            iSelectedCount++;
            [self redrawControls:YES];
        }
        else [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else [self editPhoto];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:didSelectRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( bMultiSelectMode )
    {
        iSelectedCount--;
        [self redrawControls:YES];
    }
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
        JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [photo removeFiles];
        [self.model.context deleteObject:photo];
        [self.model saveWithErrorBlock:nil];
        [self redrawControls:YES];
    }
}

#pragma mark - JMFFlickrSyncDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrSyncDelegate Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  uploadProgressForPhoto:progress:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)uploadProgressForPhoto:(JMFPhoto*)photo atIndexPath:(NSIndexPath*)indexPath progress:(float)percentage
{
    if( self.viewMode == JMFCoreDataViewModeMosaic )
    {
        JMFCameraIOS_MainCVPhotoCell* cell = (JMFCameraIOS_MainCVPhotoCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.iboSyncProgress.hidden = NO;
        cell.iboSyncProgress.progress = percentage;
        cell.bUploading = YES;
    }
    else if( self.viewMode == JMFCoreDataViewModeList )
    {
        JMFCameraIOS_MainTVCell* cell = (JMFCameraIOS_MainTVCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.iboSyncProgress.hidden = NO;
        cell.iboSyncProgress.progress = percentage;
        cell.bUploading = YES;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  didFinishUploadPhoto:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)didFinishUploadPhoto:(JMFPhoto*)photo atIndexPath:(NSIndexPath*)indexPath
{
    [self.model saveWithErrorBlock:nil];
//    [self.fetchedResultsController fetchRequest];

    if( self.viewMode == JMFCoreDataViewModeMosaic )
    {
        JMFCameraIOS_MainCVPhotoCell* cell = (JMFCameraIOS_MainCVPhotoCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.iboSyncProgress.hidden = YES;
        cell.iboSyncProgress.progress = 0.0;
        cell.iboSynchronizedIcon.hidden = NO;
        cell.iboSynchronizedIcon.layer.zPosition = 10;
        cell.bUploading = NO;
    }
    else if( self.viewMode == JMFCoreDataViewModeList )
    {
        JMFCameraIOS_MainTVCell* cell = (JMFCameraIOS_MainTVCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.iboSyncProgress.hidden = YES;
        cell.iboSyncProgress.progress = 0.0;
        cell.iboSynchronizedIcon.hidden = NO;
        cell.iboSynchronizedIcon.layer.zPosition = 10;
        cell.bUploading = NO;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  didFinishUpload                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)didFinishUpload
{
    flickrSyncTask = nil;
    bSynchronizing = NO;
    [self redrawControls:YES];
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
/*  redrawControls                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)redrawControls:(BOOL)bOnlyButtons
{
    long count = [[self.fetchedResultsController fetchedObjects]count];
    
    if( bOnlyButtons == NO )
    {
        iboEmptyAlbumLabel.hidden = YES;
        if( count <= 0 ) self.viewMode = JMFCoreDataViewModeNone;
        else if( self.viewMode == JMFCoreDataViewModeNone ) self.viewMode = JMFCoreDataViewModeMosaic;
        
        switch( self.viewMode )
        {
            case JMFCoreDataViewModeNone:
                iboEmptyAlbumLabel.hidden = NO;
                iboSelectButton.style = UIBarButtonItemStylePlain;
                iboSelectButton.enabled = NO;
                iboSelectButton.title = nil;
                break;

            case JMFCoreDataViewModeMosaic:
            case JMFCoreDataViewModeList:
                [self animateModeChange];
                iboSelectButton.style = UIBarButtonItemStyleBordered;
                iboSelectButton.enabled = ( count > 0 );
                iboSelectButton.title = ( bMultiSelectMode ) ? ResString( @"IDS_CANCEL" ) : ResString( @"IDS_SELECT" );
                break;
                
            default:
                break;
        }
    }
    
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CAMERA_INDEX] setEnabled:( !bMultiSelectMode )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX]   setEnabled:( count > 0  && !bMultiSelectMode )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setEnabled:( bMultiSelectMode && count > 0 && iSelectedCount != 0 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FLICKR_INDEX] setEnabled:( !bMultiSelectMode )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_ALBUM_INDEX]  setEnabled:( !bMultiSelectMode && count > 0 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SYNC_INDEX]   setEnabled:( bSyncToFlickrEnabled && !bSynchronizing && count > 0 )];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  scrollToBottom                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)scrollToBottom
{
    if( self.viewMode == JMFCoreDataViewModeMosaic )
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.collectionView numberOfItemsInSection:0] - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    else if( self.viewMode == JMFCoreDataViewModeList )
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  animateModeChange                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)animateModeChange
{
    if( self.oldViewMode == JMFCoreDataViewModeNone || self.oldViewMode == JMFCoreDataViewModeUnknown ||
        self.viewMode == JMFCoreDataViewModeNone || self.viewMode == self.oldViewMode )
    {
        self.collectionView.hidden = ( self.viewMode == JMFCoreDataViewModeList );
        self.tableView.hidden = ( self.viewMode == JMFCoreDataViewModeMosaic );
        return;
    }
    
    UIViewAnimationTransition animationTrnasition = ( self.oldViewMode == JMFCoreDataViewModeList ) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:animationTrnasition forView:iboContainer cache:YES];
    self.collectionView.hidden = ( self.viewMode == JMFCoreDataViewModeList );
    self.tableView.hidden = ( self.viewMode == JMFCoreDataViewModeMosaic );
    [UIView commitAnimations];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  editPhoto                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)editPhoto
{
    self.oldViewMode = self.viewMode;
    
    NSArray* selectedArray = ( self.viewMode == JMFCoreDataViewModeMosaic ) ? [self.collectionView indexPathsForSelectedItems] : [self.tableView indexPathsForSelectedRows];
    
    if( selectedArray.count == 1 )
    {
        NSIndexPath* indexPath = [selectedArray objectAtIndex:0];
        JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        JMFCameraIOS_EditViewController* editVC = [[JMFCameraIOS_EditViewController alloc] initWithPhoto:photo inModel:self.model];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSettingsClicked:                                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onSettingsClicked:(id)sender
{
    self.oldViewMode = self.viewMode;
    
    JMFCameraIOS_SettingsViewController* settingsVC = [[JMFCameraIOS_SettingsViewController alloc] initWithModel:self.model];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:settingsVC animated:NO];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSelectClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onSelectClicked:(id)sender
{
    NSArray* selectedIndexPathArray;
    selectedIndexPathArray = ( self.viewMode == JMFCoreDataViewModeMosaic ) ? [self.collectionView indexPathsForSelectedItems]
                                                                            : [self.tableView indexPathsForSelectedRows];
    if( selectedIndexPathArray != nil )
    {
        for( NSIndexPath* indexPath in selectedIndexPathArray )
        {
            if( self.viewMode == JMFCoreDataViewModeMosaic ) [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            else [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }

    bMultiSelectMode = !bMultiSelectMode;
    iboSelectButton.title = ( bMultiSelectMode ) ? ResString( @"IDS_CANCEL" ) : ResString( @"IDS_SELECT" );
    self.title = ( bMultiSelectMode ) ? ResString( @"IDS_SELECT_ITEMS" ) : ResString( @"IDS_APP_NAME" );
    self.collectionView.allowsMultipleSelection = bMultiSelectMode;
    self.tableView.allowsMultipleSelection = bMultiSelectMode;
    [self redrawControls:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCameraClicked                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onCameraClicked
{
    self.oldViewMode = self.viewMode;
    
    NSString* IDS_CANCEL        = ResString( @"IDS_CANCEL" );
    NSString* IDS_CAMERA        = ResString( @"IDS_CAMERA" );
    NSString* IDS_PHOTO_LIBRARY = ResString( @"IDS_PHOTO_LIBRARY" );
    NSString* IDS_MESSAGE       = ResString( @"IDS_CHOOSE_IMAGE_SOURCE" );
    
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:IDS_MESSAGE
                                                            delegate:nil
                                                   cancelButtonTitle:IDS_CANCEL
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:IDS_CAMERA, IDS_PHOTO_LIBRARY, nil];
    [actionSheet showFromTabBar:self.iboTabBar withCompletion:^( UIActionSheet* actionSheet, NSInteger buttonIndex )
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if( buttonIndex == 1 ) sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if( buttonIndex != 2 )
        {
            if( sourceType == UIImagePickerControllerSourceTypePhotoLibrary || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.sourceType = sourceType;
                imagePicker.allowsEditing = NO;
                imagePicker.delegate = self;
                if( sourceType == UIImagePickerControllerSourceTypeCamera )
                {
                    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
                    imagePicker.showsCameraControls = YES;
                }
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                NSString* IDS_ERROR = ResString( @"IDS_ERROR" );
                NSString* IDS_OK = ResString( @"IDS_OK" );
                NSString* IDS_NO_CAMERA_MESSAGE = ResString( @"IDS_NO_CAMERA_MESSAGE" );
                [[[UIAlertView alloc]initWithTitle:IDS_ERROR message:IDS_NO_CAMERA_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
            }
        }
    }];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onModeClicked                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onModeClicked
{
    self.oldViewMode = self.viewMode;

    iSelectedCount = 0;
    self.viewMode = ( self.viewMode == JMFCoreDataViewModeMosaic ) ? JMFCoreDataViewModeList : JMFCoreDataViewModeMosaic;
    [self redrawControls:NO];
    self.iboTabBar.items = ( self.viewMode == JMFCoreDataViewModeMosaic ) ? tbiaMosaicMode : tbiaListMode;
    [self reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDeleteClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onDeleteClicked
{
    NSArray*        selectedArray = ( self.viewMode == JMFCoreDataViewModeMosaic ) ? [self.collectionView indexPathsForSelectedItems] : [self.tableView indexPathsForSelectedRows];
    NSMutableArray* objectsArray = [[NSMutableArray alloc]init];
    
    NSString* IDS_OK        = ResString( @"IDS_OK" );
    NSString* IDS_CANCEL    = ResString( @"IDS_CANCEL" );
    NSString* IDS_MESSAGE   = ResString( @"IDS_CONFIRM_SINGLE_DELETION_MESSAGE" );
    
    if( selectedArray.count )
    {
        if( selectedArray.count > 1 ) IDS_MESSAGE = [NSString stringWithFormat:ResString( @"IDS_CONFIRM_MULTI_DELETION_MESSAGE" ), selectedArray.count ];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:IDS_MESSAGE
                                                                delegate:nil
                                                       cancelButtonTitle:IDS_CANCEL
                                                  destructiveButtonTitle:IDS_OK
                                                       otherButtonTitles:nil];
        [actionSheet showFromTabBar:self.iboTabBar withCompletion:^( UIActionSheet* actionSheet, NSInteger buttonIndex )
        {
             if( buttonIndex == 0 )
             {
                 for( NSIndexPath* indexPath in selectedArray )
                 {
                     JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                     [objectsArray addObject:photo];
                 }
                 for( JMFPhoto* photo in objectsArray )
                 {
                     [photo removeFiles];
                     [self.model.context deleteObject:photo];
                 }
                 [objectsArray removeAllObjects];
                 [self.model saveWithErrorBlock:nil];
                 iSelectedCount = 0;
                 if( [self.fetchedResultsController fetchedObjects].count == 0 ) [self onSelectClicked:self];
                 [self redrawControls:NO];
             }
        }];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFlickrClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onFlickrClicked
{
    NSString* IDS_OK                = ResString( @"IDS_OK" );
    NSString* IDS_CANCEL            = ResString( @"IDS_CANCEL" );
    NSString* IDS_MESSAGE           = ResString( @"IDS_DOWNLOAD_FROM_FLICKR_MESSAGE" );
    NSString* IDS_PLACEHOLDER       = ResString( @"IDS_DOWNLOAD_FROM_FLICKR_PLACEHOLDER" );
    NSString* IDS_DOWNLOADING       = ResString( @"IDS_DOWNLOADING_PICTURES" );
    NSString* IDS_DOWNLOADING_ERROR = ResString( @"IDS_DOWNLOADING_PICTURES_ERROR" );
    
    self.oldViewMode = self.viewMode;
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Flickr" message:IDS_MESSAGE delegate:nil cancelButtonTitle:IDS_CANCEL otherButtonTitles:IDS_OK, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].placeholder = IDS_PLACEHOLDER;
    [alertView showWithCompletion:^( UIAlertView* alertView, NSInteger buttonIndex )
    {
        NSString* searchTerm = [alertView textFieldAtIndex:0].text;
        if( buttonIndex == 1 && ![searchTerm isEqualToString:@""] )
        {
            UIAlertView* busyAlertView = [[UIAlertView alloc]initWithTitle:@"Flickr" message:IDS_DOWNLOADING delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [busyAlertView showWithActivityIndicatorWithColor:[UIColor darkTextColor]];
            
            [JMFFlickr flickrSearchForTerm:searchTerm largeImage:YES completionBlock:^( NSString* searchTerm, NSArray* results, NSError* error )
            {
                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                     if( !error )
                     {
                         for( JMFFlickrPhoto* flickrPhoto in results )
                         {
                             if( flickrPhoto.largeImage != nil && flickrPhoto.thumbnail != nil )
                             {
                                 JMFPhoto* newPhoto = [JMFPhoto photoWithImage:flickrPhoto.largeImage
                                                                        source:JMFPhotoSourceFlickr
                                                                     thumbnail:flickrPhoto.thumbnail
                                                                     inContext:self.model.context];
                                 [newPhoto setLocationLongitude:currentLongitude latitude:currentLatitude altitude:currentAltitude geoLocation:currentGeoLocation];
                             }
                         }
                         if( results.count > 0 )
                         {
                             [self.model saveWithErrorBlock:nil];
                             [self reloadData];
                             [self scrollToBottom];
                         }
                     }
                     
                     [busyAlertView dismissWithClickedButtonIndex:0 animated:YES];
                     if( !error ) [self redrawControls:NO];
                     else [[[UIAlertView alloc]initWithTitle:@"Error" message:IDS_DOWNLOADING_ERROR delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
                 });
            }];
        }
    }];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onAlbumClicked:                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onAlbumClicked
{
    self.oldViewMode = self.viewMode;
    
    JMFCameraIOS_AlbumViewController* albumVC = [[JMFCameraIOS_AlbumViewController alloc] initWithFetchedResultsController:self.fetchedResultsController];
    [self.navigationController pushViewController:albumVC animated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSyncClicked:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onSyncClicked
{
    if( bSyncToFlickrEnabled )
    {
        [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SYNC_INDEX] setEnabled:NO];
        bSynchronizing = YES;
        flickrSyncTask = [[JMFFlickrSync alloc]initWithFetchedResultsController:self.fetchedResultsController delegate:self];
        [flickrSyncTask start];
    }
}

@end
