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
#import "JMFFlickr.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_MAINCV_PHOTO_CELL_XIBNAME       @"JMFCameraIOS_MainCVPhotoCell"
#define IDS_MAINCV_PHOTO_CELL_IDENTIFIER    @"MainCVPhotoCellIdentifier"
#define IDS_MAINTV_PHOTO_CELL_IDENTIFIER    @"MainTVPhotoCellIdentifier"

#define IDC_UITOOLBAR_BUTTON_CAMERA_INDEX   0
#define IDC_UITOOLBAR_BUTTON_MODE_INDEX     1
#define IDC_UITOOLBAR_BUTTON_EDIT_INDEX     2
#define IDC_UITOOLBAR_BUTTON_DELETE_INDEX   3
#define IDC_UITOOLBAR_BUTTON_FLICKR_INDEX   4

#define VIEW_MODE_MOSAIC                    0
#define VIEW_MODE_LIST                      1

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController ()
{
    UICollectionView*       photoCollectionView;
    UITableView*            photoTableView;
    NSMutableArray*         album;
    int                     iViewMode;
    int                     iSelectedCount;
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
/*  initWithNibName:bundle:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self )
    {
        self.title = @"JMFCameraIOS";
        album = [[NSMutableArray alloc]init];
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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.iboEmptyAlbumLabel.text = NSLocalizedString( @"IDS_EMPTY_ALBUM_MESSAGE", nil );
    
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CAMERA_INDEX] setTitle:NSLocalizedString( @"IDS_CAMERA", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX]   setTitle:NSLocalizedString( @"IDS_MODE",   nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_EDIT_INDEX]   setTitle:NSLocalizedString( @"IDS_EDIT",   nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setTitle:NSLocalizedString( @"IDS_DELETE", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FLICKR_INDEX] setTitle:NSLocalizedString( @"IDS_FLICKR", nil )];
    
    // Collection View
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake( 20, 0, 20, 0 );
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.iboTabBar.frame.size.height;
    
    CGRect Rect = CGRectMake( 0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - tabBarHeight );
    photoCollectionView = [[UICollectionView alloc]initWithFrame:Rect collectionViewLayout:layout];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    photoCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    photoCollectionView.allowsMultipleSelection = YES;
    
    [photoCollectionView registerNib:[UINib nibWithNibName:IDS_MAINCV_PHOTO_CELL_XIBNAME bundle:nil] forCellWithReuseIdentifier:IDS_MAINCV_PHOTO_CELL_IDENTIFIER];
    [self.view addSubview:photoCollectionView];
    
    //Table View
    navBarHeight += 20;
    CGRect tvRect = CGRectMake( 0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - tabBarHeight );
    photoTableView = [[UITableView alloc]initWithFrame:tvRect style:UITableViewStylePlain];
    photoTableView.dataSource = self;
    photoTableView.delegate = self;
    photoTableView.allowsMultipleSelection = YES;
    [photoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDS_MAINTV_PHOTO_CELL_IDENTIFIER];
    [self.view addSubview:photoTableView];
    
    //UILabel
    [self.iboEmptyAlbumLabel setFrame:Rect];
    
    iViewMode = VIEW_MODE_MOSAIC;
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
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.iboTabBar.frame.size.height;
    
    CGRect Rect = CGRectMake( 0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - tabBarHeight );
    [photoCollectionView setFrame:Rect];
    
    navBarHeight += 20;
    CGRect tvRect = CGRectMake( 0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - tabBarHeight );
    [photoTableView setFrame:tvRect];

    [self.iboEmptyAlbumLabel setFrame:Rect];

    iSelectedCount = 0;
    [self redrawControls:NO];
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
        case IDC_UITOOLBAR_BUTTON_EDIT_INDEX:   [self onEditClicked];       break;
        case IDC_UITOOLBAR_BUTTON_DELETE_INDEX: [self onDeleteClicked];     break;
        case IDC_UITOOLBAR_BUTTON_FLICKR_INDEX: [self onFlickrClicked];     break;
    }
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
    UIImage* photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    [album addObject:photo];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self redrawControls:NO];
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
    return CGSizeMake( 100, 100 );
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
    return UIEdgeInsetsMake( 50, 20, 50, 20 );
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
/*  numberOfSectionsInCollectionView:                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}


/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:numberOfItemsInSection:                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [album count];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:numberOfItemsInSection:                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    JMFCameraIOS_MainCVPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDS_MAINCV_PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iboPhotoImage.image = [album objectAtIndex:indexPath.item];
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
    NSLog( @"Cell selected: item %d in section %d", indexPath.item, indexPath.section );
    iSelectedCount++;
    [self redrawControls:YES];
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
    NSLog( @"Cell deselected: item %d in section %d", indexPath.item, indexPath.section );
    iSelectedCount--;
    [self redrawControls:YES];
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
/*  numberOfSectionsInTableView:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  titleForHeaderInSection:                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString( @"IDS_PICTURES", nil );
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
    return album.count;
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
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:IDS_MAINTV_PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Photo for row #%d", indexPath.row];
    cell.imageView.image = [album objectAtIndex:indexPath.row];
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
/*  tableView:didSelectRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog( @"Cell selected: row %d in section %d", indexPath.item, indexPath.section );
    iSelectedCount++;
    [self redrawControls:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:didSelectRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog( @"Cell deselected: row %d in section %d", indexPath.row, indexPath.section );
    iSelectedCount--;
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
    if( bOnlyButtons == NO )
    {
        if( !album.count ) iViewMode = VIEW_MODE_MOSAIC;
        photoCollectionView.hidden = ( !album.count || iViewMode != VIEW_MODE_MOSAIC );
        photoTableView.hidden = ( !album.count || iViewMode != VIEW_MODE_LIST );
        self.iboEmptyAlbumLabel.hidden = ( album.count );
    }
    
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX] setEnabled:( album.count )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_EDIT_INDEX] setEnabled:( album.count && iSelectedCount == 1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setEnabled:( album.count && iSelectedCount != 0 )];
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
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        NSString* IDS_ERROR = NSLocalizedString( @"IDS_ERROR", @"" );
        NSString* IDS_OK = NSLocalizedString( @"IDS_OK", @"" );
        NSString* IDS_NO_CAMERA_MESSAGE = NSLocalizedString( @"IDS_NO_CAMERA_MESSAGE", @"" );
        [[[UIAlertView alloc]initWithTitle:IDS_ERROR message:IDS_NO_CAMERA_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
    }
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
    iSelectedCount = 0;
    iViewMode = ( iViewMode == VIEW_MODE_MOSAIC ) ? VIEW_MODE_LIST : VIEW_MODE_MOSAIC;
    NSLog(@"View Mode: %d", iViewMode);
    [self redrawControls:NO];

//    UIImage* icon = [UIImage imageNamed:( iViewMode == VIEW_MODE_MOSAIC ) ? @"MosaicMode.png" : @"ListMode.png" ];
//    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX] setImage:icon forState:UIControlStateSelected];

    if( iViewMode == VIEW_MODE_MOSAIC ) [photoCollectionView reloadData];
    else [photoTableView reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCameraClicked                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onEditClicked
{
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
    NSString* IDS_OK                = NSLocalizedString( @"IDS_OK", @"" );
    NSString* IDS_CANCEL            = NSLocalizedString( @"IDS_CANCEL", @"" );
    NSString* IDS_MESSAGE           = NSLocalizedString( @"IDS_DOWNLOAD_FROM_FLICKR_MESSAGE", @"" );
    NSString* IDS_PLACEHOLDER       = NSLocalizedString( @"IDS_DOWNLOAD_FROM_FLICKR_PLACEHOLDER", @"" );
    NSString* IDS_DOWNLOADING       = NSLocalizedString( @"IDS_DOWNLOADING_PICTURES", @"" );
    NSString* IDS_DOWNLOADING_ERROR = NSLocalizedString( @"IDS_DOWNLOADING_PICTURES_ERROR", @"" );
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Flickr" message:IDS_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:IDS_CANCEL, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].placeholder = IDS_PLACEHOLDER;
    [alertView showWithCompletion:^( UIAlertView* alertView, NSInteger buttonIndex )
    {
         if( buttonIndex == 0 )
         {
             UIAlertView* busyAlertView = [[UIAlertView alloc]initWithTitle:@"Flickr" message:IDS_DOWNLOADING delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
             [busyAlertView showWithActivityIndicatorWithColor:[UIColor darkTextColor]];

             JMFFlickr* flickrEngine = [[JMFFlickr alloc]init];
             [flickrEngine searchFlickrForTerm:[alertView textFieldAtIndex:0].text
                               completionBlock:^( NSString* searchTerm, NSArray* results, NSError* error )
              {
                  [busyAlertView dismissWithClickedButtonIndex:0 animated:YES];
                  if( !error )
                  {
                      for( JMFFlickrPhoto* photo in results )
                      {
                          if( photo.largeImage != nil ) [album addObject:photo.largeImage];
                          else if( photo.thumbnail != nil ) [album addObject:photo.thumbnail];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^
                      {
                          [self redrawControls:NO];
                          [self->photoCollectionView reloadData];
                      });
                  }
                  else
                  {
                      NSLog( @"Error receiving Flickr photos: %@", error );
                      [[[UIAlertView alloc]initWithTitle:@"Error" message:IDS_DOWNLOADING_ERROR delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
                  }
              }];
         }
    }];
}

@end
