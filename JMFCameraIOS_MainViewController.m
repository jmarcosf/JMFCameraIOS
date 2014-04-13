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

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController ()

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
    self.iboEmptyAlbumLabel.text = NSLocalizedString( @"IDS_EMPTY_ALBUM_MESSAGE", @"Comment String" );

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem* button = [self.iboToolbar.items objectAtIndex:0];
//    button.image = [UIImage imageNamed:@"Camera.png"];// forState:UIControlStateNormal];
    
    button.title = @"Camera";
    
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

#pragma mark - IBAction Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  IBAction Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCameraClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onCameraClicked:(id)sender
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
/*  onModeClicked:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onModeClicked:(id)sender
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCameraClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onEditClicked:(id)sender
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDeleteClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onDeleteClicked:(id)sender
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFlickrClicked:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onFlickrClicked:(id)sender
{
    NSString* IDS_OK = NSLocalizedString( @"IDS_OK", @"" );
    NSString* IDS_CANCEL = NSLocalizedString( @"IDS_CANCEL", @"" );
    NSString* IDS_MESSAGE = NSLocalizedString( @"IDS_DOWNLOAD_FROM_FLICKR_MESSAGE", @"" );
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Flickr" message:IDS_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:IDS_CANCEL, nil];
    [alertView showWithCompletion:^( UIAlertView *alertView, NSInteger buttonIndex )
                                  {
                                      if( buttonIndex == 0 )
                                      {
//                                          [[[UIAlertView alloc]initWithTitle:@"Flickr"
//                                                                     message:@"Downloading pictures..."
//                                                                    delegate:nil
//                                                           cancelButtonTitle:nil
//                                                           otherButtonTitles:nil] show];
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
    UIImage *originalPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
//    self.photoView.image = originalPhoto;
    
//    UIImageWriteToSavedPhotosAlbum( originalPhoto, nil, NULL, NULL );
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
