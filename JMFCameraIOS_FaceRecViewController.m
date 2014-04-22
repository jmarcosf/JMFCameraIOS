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
#define EYE_SIZE_RATE                       0.3f
#define MOUTH_SIZE_RATE                     0.4f

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FaceRecViewController ()
{
    UIView*     faceView;
    UIView*     leftEyeView;
    UIView*     rightEyeView;
    UIView*     mouthView;
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
/*  initWithImage:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithImage:(UIImage*)image
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
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
/*  initWithNibName:bundle:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self )
    {
        // Custom initialization
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
    self.title = NSLocalizedString( @"IDS_FACE_DETECTION", nil );
    self.iboImageView.image = self.image;
    
    self.iboFaceLabelTitle.text     = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_FACE",      nil )];
    self.iboLeftEyeLabelTitle.text  = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_LEFT_EYE",  nil )];
    self.iboRightEyeLabelTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_RIGHT_EYE", nil )];
    self.iboMouthLabelTitle.text    = [NSString stringWithFormat:@"%@:", NSLocalizedString( @"IDS_MOUTH",     nil )];
    
    self.iboDetectButton.title      = NSLocalizedString( @"IDS_DETECT", nil );
    self.iboClearButton.title       = NSLocalizedString( @"IDS_CLEAR",  nil );
    self.iboCancelButton.title      = NSLocalizedString( @"IDS_CANCEL", nil );
    self.iboApplyButton.title       = NSLocalizedString( @"IDS_APPLY",  nil );
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
    [self onClear:self];
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
/*  onDetect:                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onDetect:(id)sender
{
    self.iboActivityIndicator.hidden = NO;
    [self.iboActivityIndicator startAnimating];
    NSString* detectingString = [NSString stringWithFormat:@"%@...", NSLocalizedString( @"IDS_DETECTING", nil )];
    self.iboFaceLabel.font = self.iboLeftEyeLabel.font = self.iboRightEyeLabel.font = self.iboMouthLabel.font = [UIFont italicSystemFontOfSize:12.0];
    self.iboFaceLabel.text = self.iboLeftEyeLabel.text = self.iboRightEyeLabel.text = self.iboMouthLabel.text = detectingString;
    self.iboDetectButton.enabled = NO;
    
    dispatch_queue_t detectQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0 );
    dispatch_async( detectQueue, ^
    {
        [self detectFaceWithCompletionBlock:^( bool bDetected )
        {
            self.iboDetectButton.enabled = !bDetected;
            self.iboClearButton.enabled = bDetected;
            self.iboApplyButton.enabled = bDetected;
            [self.iboActivityIndicator stopAnimating];
            self.iboActivityIndicator.hidden = YES;
            self.iboFaceLabel.font = self.iboLeftEyeLabel.font = self.iboRightEyeLabel.font = self.iboMouthLabel.font = [UIFont systemFontOfSize:18.0];
            if( !bDetected ) self.iboFaceLabel.text = self.iboLeftEyeLabel.text = self.iboRightEyeLabel.text = self.iboMouthLabel.text = @"";
        }];
    });
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onClear:                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onClear:(id)sender
{
    [faceView removeFromSuperview];
    [leftEyeView removeFromSuperview];
    [rightEyeView removeFromSuperview];
    [mouthView removeFromSuperview];
    faceView = leftEyeView = rightEyeView = mouthView = nil;
    self.iboDetectButton.enabled = YES;
    self.iboClearButton.enabled = NO;
    self.iboApplyButton.enabled = NO;
    self.iboFaceLabel.text = self.iboLeftEyeLabel.text = self.iboRightEyeLabel.text = self.iboMouthLabel.text = @"";
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onCancel:                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onApply:                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onApply:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
/*  detectFace:                                                            */
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
        //Only first face is supported for this practice. Interchange next 2 lines to support every recognized face
        CIFaceFeature* faceFeature = [features objectAtIndex:0];
        //for( CIFaceFeature* faceFeature in features )
        {
            // Draw Face Rect
            const CGRect faceRect = CGRectApplyAffineTransform( [self.iboImageView convertRectFromImage:faceFeature.bounds], transform );
            faceView = [[UIView alloc] initWithFrame:faceRect];
            faceView.layer.borderWidth = 1.5f;
            faceView.layer.borderColor = [[UIColor greenColor] CGColor];
            CGFloat faceWidth = faceRect.size.width;
            [self.iboImageView addSubview:faceView];
            self.iboFaceLabel.text = [NSString stringWithFormat:@"(%.0f,%.0f),(%.0f,%.0f)",
                                      faceFeature.bounds.origin.x, faceFeature.bounds.origin.y,
                                      faceFeature.bounds.size.width, faceFeature.bounds.size.height];
            //Draw Left Eye
            if( faceFeature.hasLeftEyePosition )
            {
                const CGPoint leftEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.leftEyePosition], transform );
                leftEyeView = [[UIView alloc] initWithFrame:CGRectMake( leftEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, leftEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                       faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
                leftEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
                leftEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5f;
                [self.iboImageView addSubview:leftEyeView];
                self.iboLeftEyeLabel.text = [NSString stringWithFormat:@"(%.0f,%.0f)", faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y];
            }
            
            //Draw Right Eye
            if( faceFeature.hasRightEyePosition )
            {
                const CGPoint rightEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.rightEyePosition], transform );
                rightEyeView = [[UIView alloc] initWithFrame:CGRectMake( rightEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, rightEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                        faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
                rightEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
                rightEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5;
                [self.iboImageView addSubview:rightEyeView];
                self.iboRightEyeLabel.text = [NSString stringWithFormat:@"(%.0f,%.0f)", faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y];
            }
            
            //Draw Mouth
            if( faceFeature.hasMouthPosition )
            {
                const CGPoint mouthPos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:faceFeature.mouthPosition], transform );
                mouthView = [[UIView alloc] initWithFrame:CGRectMake( mouthPos.x - faceWidth * MOUTH_SIZE_RATE * 0.5f, mouthPos.y - faceWidth * MOUTH_SIZE_RATE * 0.5f,
                                                                     faceWidth * MOUTH_SIZE_RATE, faceWidth * MOUTH_SIZE_RATE)];
                mouthView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3f];
                mouthView.layer.cornerRadius = faceWidth * MOUTH_SIZE_RATE * 0.5f;
                [self.iboImageView addSubview:mouthView];
                self.iboMouthLabel.text = [NSString stringWithFormat:@"(%.0f,%.0f)", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y];
            }
        }
    }
    
    if( completionBlock ) completionBlock( features.count != 0 );
}

@end