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

#define VIEW_MODE_WELCOME                   0
#define VIEW_MODE_MOSAIC                    1
#define VIEW_MODE_LIST                      2

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController ()
{
    CGFloat                 statusBarHeight;
    CGFloat                 navigationBarHeight;
    CGFloat                 tabBarHeight;
    
    UILabel*                iboEmptyAlbumLabel;
    UICollectionView*       iboCollectionView;
    UITableView*            iboTableView;
    
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
        iSelectedCount = 0;
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

    self.navigationController.navigationBar.translucent = NO;
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    tabBarHeight = self.iboTabBar.frame.size.height;
    
    CGRect Rect = CGRectMake( 0, 0, 0, 0 );
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.iboTabBar.delegate = self;

    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CAMERA_INDEX] setTitle:NSLocalizedString( @"IDS_CAMERA", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX]   setTitle:NSLocalizedString( @"IDS_MODE",   nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_EDIT_INDEX]   setTitle:NSLocalizedString( @"IDS_EDIT",   nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setTitle:NSLocalizedString( @"IDS_DELETE", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FLICKR_INDEX] setTitle:NSLocalizedString( @"IDS_FLICKR", nil )];

    //UILabel
    iboEmptyAlbumLabel = [[UILabel alloc]initWithFrame:Rect];
    iboEmptyAlbumLabel.backgroundColor = [UIColor redColor];
    iboEmptyAlbumLabel.textAlignment = NSTextAlignmentCenter;
    iboEmptyAlbumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    iboEmptyAlbumLabel.numberOfLines = 10;
    iboEmptyAlbumLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    iboEmptyAlbumLabel.text = NSLocalizedString( @"IDS_EMPTY_ALBUM_MESSAGE", nil );
    [self.view addSubview:iboEmptyAlbumLabel];
    
    // Collection View
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumLineSpacing = 10;
//    layout.sectionInset = UIEdgeInsetsMake( 20, 0, 20, 0 );
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    iboCollectionView = [[UICollectionView alloc]initWithFrame:Rect collectionViewLayout:layout];
    iboCollectionView.dataSource = self;
    iboCollectionView.delegate = self;
    iboCollectionView.backgroundColor = [UIColor orangeColor];//   groupTableViewBackgroundColor];
    iboCollectionView.allowsMultipleSelection = YES;
    
    [iboCollectionView registerNib:[UINib nibWithNibName:IDS_MAINCV_PHOTO_CELL_XIBNAME bundle:nil] forCellWithReuseIdentifier:IDS_MAINCV_PHOTO_CELL_IDENTIFIER];
    [self.view addSubview:iboCollectionView];
    
    //Table View
    iboTableView = [[UITableView alloc]initWithFrame:Rect style:UITableViewStylePlain];
    iboTableView.dataSource = self;
    iboTableView.delegate = self;
    iboTableView.backgroundColor = [UIColor yellowColor]; // groupTableViewBackgroundColor];
    iboTableView.allowsMultipleSelection = YES;
    [iboTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDS_MAINTV_PHOTO_CELL_IDENTIFIER];
    [self.view addSubview:iboTableView];
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
    NSLog( @"viewWillAppear()" );
    
    CGRect Rect = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );
    Rect.size.height -= tabBarHeight;
    [iboEmptyAlbumLabel setFrame:Rect];
    Rect.size.height -= statusBarHeight;
    [iboCollectionView setFrame:Rect];
    [iboTableView setFrame:Rect];
    
    [self redrawControls:NO];
    [self.view bringSubviewToFront:iboEmptyAlbumLabel];
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
    NSLog( @"didReceiveMemoryWarning()" );
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
    NSLog( @"imagePickerController:didFinishPickingMediaWithInfo()" );
    
    UIImage* photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    [album addObject:photo];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self reloadData];
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
//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake( 50, 20, 50, 20 );
//}

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
    cell.iboSelectedIcon.image = [UIImage imageNamed:@"Checked.png"];
    cell.iboSelectedIcon.hidden = YES;
    cell.iboSelectedIcon.layer.zPosition = 100;
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
    NSLog( @"Cell selected: item %ld in section %ld", (long)indexPath.item, (long)indexPath.section );
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
    NSLog( @"Cell deselected: item %ld in section %ld", (long)indexPath.item, (long)indexPath.section );
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
    cell.textLabel.text = [NSString stringWithFormat:@"Photo for row #%ld", (long)indexPath.row];
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
    NSLog( @"Cell selected: row %ld in section %ld", (long)indexPath.item, (long)indexPath.section );
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
    NSLog( @"Cell deselected: row %ld in section %ld", (long)indexPath.row, (long)indexPath.section );
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
    NSLog( @"redrawControls()" );

    if( bOnlyButtons == NO )
    {
        iboEmptyAlbumLabel.hidden = iboCollectionView.hidden = iboTableView.hidden = YES;
        if( album.count <= 0 ) iViewMode = VIEW_MODE_WELCOME;
        else if( iViewMode == VIEW_MODE_WELCOME ) iViewMode = VIEW_MODE_MOSAIC;
        
        NSLog( @"View Mode: %d", iViewMode );
        switch( iViewMode )
        {
            case VIEW_MODE_WELCOME:     iboEmptyAlbumLabel.hidden = NO;       break;
            case VIEW_MODE_MOSAIC:      iboCollectionView.hidden = NO;        break;
            case VIEW_MODE_LIST:        iboTableView.hidden = NO;             break;
        }
    }
    
    NSLog( @"album count: %lu", (unsigned long)album.count );
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX] setEnabled:( album.count > 0 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_EDIT_INDEX] setEnabled:( album.count > 0 && iSelectedCount == 1 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DELETE_INDEX] setEnabled:( album.count > 0 && iSelectedCount != 0 )];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  reloadData                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)reloadData
{
    if( iViewMode == VIEW_MODE_MOSAIC ) [iboCollectionView reloadData];
    else if( iViewMode == VIEW_MODE_LIST ) [iboTableView reloadData];
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
    NSLog( @"onModeClicked()" );
    
    iSelectedCount = 0;
    iViewMode = ( iViewMode == VIEW_MODE_MOSAIC ) ? VIEW_MODE_LIST : VIEW_MODE_MOSAIC;
    [self redrawControls:NO];

//    UIImage* icon = [UIImage imageNamed:( iViewMode == VIEW_MODE_MOSAIC ) ? @"MosaicMode.png" : @"ListMode.png" ];
//    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_MODE_INDEX] setImage:icon forState:UIControlStateSelected];

    [self reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onEditClicked                                                          */
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
    if( iSelectedCount > 0 )
    {
        if( iViewMode == VIEW_MODE_MOSAIC )
        {
            NSArray* selectedArray = [iboCollectionView indexPathsForSelectedItems];
            if( selectedArray.count )
            {
                NSMutableIndexSet* indexSet = [[NSMutableIndexSet alloc]init];
                for( NSIndexPath* indexPath in selectedArray )
                {
                    [indexSet addIndex:indexPath.item];
                }
                [album removeObjectsAtIndexes:indexSet];
                iSelectedCount = 0;
                [self redrawControls:YES];
                [iboCollectionView reloadData];
            }
        }
        else if( iViewMode == VIEW_MODE_LIST )
        {
            NSArray* selectedArray = [iboTableView indexPathsForSelectedRows];
            if( selectedArray.count )
            {
                NSMutableIndexSet* indexSet = [[NSMutableIndexSet alloc]init];
                for( NSIndexPath* indexPath in selectedArray )
                {
                    [indexSet addIndex:indexPath.row];
                }
                [album removeObjectsAtIndexes:indexSet];
                iSelectedCount = 0;
                [self redrawControls:YES];
                [iboTableView reloadData];
            }
        }
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
    NSString* IDS_OK                = NSLocalizedString( @"IDS_OK", @"" );
    NSString* IDS_CANCEL            = NSLocalizedString( @"IDS_CANCEL", @"" );
    NSString* IDS_MESSAGE           = NSLocalizedString( @"IDS_DOWNLOAD_FROM_FLICKR_MESSAGE", @"" );
    NSString* IDS_PLACEHOLDER       = NSLocalizedString( @"IDS_DOWNLOAD_FROM_FLICKR_PLACEHOLDER", @"" );
    NSString* IDS_DOWNLOADING       = NSLocalizedString( @"IDS_DOWNLOADING_PICTURES", @"" );
    NSString* IDS_DOWNLOADING_ERROR = NSLocalizedString( @"IDS_DOWNLOADING_PICTURES_ERROR", @"" );
    
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
            
            JMFFlickr* flickrEngine = [[JMFFlickr alloc]init];
            [flickrEngine searchFlickrForTerm:searchTerm completionBlock:^( NSString* searchTerm, NSArray* results, NSError* error )
             {
                 if( !error )
                 {
                     for( JMFFlickrPhoto* photo in results )
                     {
                         if( photo.largeImage != nil ) [album addObject:photo.largeImage];
                         else if( photo.thumbnail != nil ) [album addObject:photo.thumbnail];
                     }
                 }
                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                     [busyAlertView dismissWithClickedButtonIndex:0 animated:YES];
                     if( !error )
                     {
                         [self redrawControls:NO];
                         [self reloadData];
                     }
                     else
                     {
                         NSLog( @"Error receiving Flickr photos: %@", error );
                         [[[UIAlertView alloc]initWithTitle:@"Error" message:IDS_DOWNLOADING_ERROR delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
                     }
                 });
             }];
        }
    }];
}

@end
