/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController.m                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Face Recognition View Controller Class implementation file*/
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FaceRecViewController.h"
#import "UIImageView+GeometryConversion.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDC_UITOOLBAR_BUTTON_DETECT_INDEX           0
#define IDC_UITOOLBAR_BUTTON_CLEAR_INDEX            1
#define IDC_UITOOLBAR_BUTTON_CANCEL_INDEX           2
#define IDC_UITOOLBAR_BUTTON_APPLY_INDEX            3

#define EYE_SIZE_RATE                               0.3f
#define MOUTH_SIZE_RATE                             0.4f

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FaceRecViewController ()
{
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Implemantation                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FaceRecViewController

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
/*  initWithPhoto:andImage:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.photo = photo;
        self.image = image;
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
    self.title = NSLocalizedString( @"IDS_FACE_DETECTION", nil );
    if( self.image == nil ) self.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboImageView.image = self.image;
    
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX]     setTitle:NSLocalizedString( @"IDS_DETECT", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]      setTitle:NSLocalizedString( @"IDS_CLEAR", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX]     setTitle:NSLocalizedString( @"IDS_CANCEL", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]      setTitle:NSLocalizedString( @"IDS_APPLY", nil )];
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
    self.iboActivityIndicator.hidden = YES;
    [self.iboActivityIndicator stopAnimating];
    [self onClearClicked];
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
        case IDC_UITOOLBAR_BUTTON_DETECT_INDEX:     [self onDetectClicked];     break;
        case IDC_UITOOLBAR_BUTTON_CLEAR_INDEX:      [self onClearClicked];      break;
        case IDC_UITOOLBAR_BUTTON_CANCEL_INDEX:     [self onCancelClicked];     break;
        case IDC_UITOOLBAR_BUTTON_APPLY_INDEX:      [self onApplyClicked];      break;
    }
}

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
/*  onDetectClicked                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onDetectClicked
{
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( NO )];
    self.iboActivityIndicator.hidden = NO;
    [self.iboActivityIndicator startAnimating];
    
    dispatch_queue_t detectQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 );
    dispatch_async( detectQueue, ^
    {
        [self detectFaceWithCompletionBlock:^( bool bDetected )
        {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async( mainQueue, ^
            {
                [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( !bDetected )];
                [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX] setEnabled:( bDetected )];
                [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX] setEnabled:( bDetected )];
                self.iboActivityIndicator.hidden = YES;
                [self.iboActivityIndicator stopAnimating];
            });
        }];
    });
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
    NSArray* subViewArray = [self.iboImageView subviews];
    for( UIView* view in subViewArray )
    {
        [view removeFromSuperview];
    }
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( YES )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX] setEnabled:( NO )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX] setEnabled:( NO )];
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
/*  onApplyClicked                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onApplyClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  detectFaceWithCompletionBlock:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)detectFaceWithCompletionBlock:( void (^)( bool bDetected ) )completionBlock
{
 	CIImage*        image    = [CIImage imageWithCGImage:self.iboImageView.image.CGImage];
    NSDictionary*   options  = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
 	CIDetector*     detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
	NSArray*        features = [detector featuresInImage:image];
    
	// For convert CoreImage coordinates to UIKit coordinates
	CGAffineTransform transform = CGAffineTransformMakeScale( 1, -1 );
	transform = CGAffineTransformTranslate( transform, 0, - self.iboImageView.bounds.size.height );
	
    if( features.count != 0 )
    {
        for( CIFaceFeature* faceFeature in features )
        {
            // Draw Face Rect
            const CGRect faceRect = CGRectApplyAffineTransform( [self.iboImageView convertRectFromImage:faceFeature.bounds], transform );
            UIView* faceView = [[UIView alloc] initWithFrame:faceRect];
            faceView.layer.borderWidth = 1.5f;
            faceView.layer.borderColor = [[UIColor greenColor] CGColor];
            [self showFaceFeature:faceView];
            CGFloat faceWidth = faceRect.size.width;

            //Draw Left Eye
            if( faceFeature.hasLeftEyePosition )
            {
                const CGPoint leftEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.leftEyePosition], transform );
                UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake( leftEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, leftEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                                faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
                leftEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
                leftEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5f;
                [self showFaceFeature:leftEyeView];
            }
            
            //Draw Right Eye
            if( faceFeature.hasRightEyePosition )
            {
                const CGPoint rightEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.rightEyePosition], transform );
                UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake( rightEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, rightEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                                 faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
                rightEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
                rightEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5;
                [self showFaceFeature:rightEyeView];
            }
            
            //Draw Mouth
            if( faceFeature.hasMouthPosition )
            {
                const CGPoint mouthPos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.mouthPosition], transform );
                UIView* mouthView = [[UIView alloc] initWithFrame:CGRectMake( mouthPos.x - faceWidth * MOUTH_SIZE_RATE * 0.5f, mouthPos.y - faceWidth * MOUTH_SIZE_RATE * 0.5f,
                                                                              faceWidth * MOUTH_SIZE_RATE, faceWidth * MOUTH_SIZE_RATE)];
                mouthView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3f];
                mouthView.layer.cornerRadius = faceWidth * MOUTH_SIZE_RATE * 0.5f;
                [self showFaceFeature:mouthView];
            }
        }
    }
    
    if( completionBlock ) completionBlock( features.count != 0 );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showFaceFeature:withText:forLabel:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showFaceFeature:(UIView*)view
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async( mainQueue, ^
    {
        [self.iboImageView addSubview:view];
    });
}

@end