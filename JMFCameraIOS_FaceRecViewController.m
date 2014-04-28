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
#import "JMFFace.h"
#import "JMFAppDelegate.h"

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
/*  JMFFace Flags                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#pragma pack( 1 )
typedef struct _FACE_FEATURE_TAG_
{
    CGRect      faceRect;
    CGPoint     leftEyePoint;
    CGPoint     rightEyePoint;
    CGPoint     mouthPoint;
    int32_t     faceFlags;
} FACE_FEATURE;
#pragma pack()

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FaceRecViewController ()
{
    NSFetchedResultsController*     fetchResultsController;
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

    [self drawFaces];
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
/*  drawFaces                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)drawFaces
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[JMFFace entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.creationDate ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.photo.managedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    NSError *error;
    [fetchResultsController performFetch:&error];
    
    int count = [[fetchResultsController fetchedObjects]count];;
    for( int i = 0; i < count; i++ )
    {
        JMFFace* face = [fetchResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self drawFace:face];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  drawFace:                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)drawFace:(JMFFace*)face
{
	// For convert CoreImage coordinates to UIKit coordinates
	CGAffineTransform transform = CGAffineTransformMakeScale( 1, -1 );
	transform = CGAffineTransformTranslate( transform, 0, - self.iboImageView.bounds.size.height );
//    CIImage* image = [CIImage imageWithCGImage:self.iboImageView.image.CGImage];
    
    // Draw Face Rect
    CGRect imageFaceRect = CGRectFromString( face.faceRect );
    const CGRect faceRect = CGRectApplyAffineTransform( [self.iboImageView convertRectFromImage:imageFaceRect], transform );
    UIView* faceView = [[UIView alloc] initWithFrame:faceRect];
    faceView.layer.borderWidth = 1.5f;
    faceView.layer.borderColor = [[UIColor greenColor] CGColor];
    [self drawFeature:faceView];
    CGFloat faceWidth = faceRect.size.width;
    
    //Draw Left Eye
    if( face.hasLeftEye )
    {
        CGPoint imageLeftEyePosition = CGPointFromString( face.leftEyePoint );
        const CGPoint leftEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:imageLeftEyePosition], transform );
        UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake( leftEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, leftEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                       faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
        leftEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
        leftEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5f;
        [self drawFeature:leftEyeView];
    }
    
    //Draw Right Eye
    if( face.hasRightEye )
    {
        CGPoint imageRightEyePosition = CGPointFromString( face.rightEyePoint );
        const CGPoint rightEyePos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:imageRightEyePosition], transform );
        UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake( rightEyePos.x - faceWidth * EYE_SIZE_RATE * 0.5f, rightEyePos.y - faceWidth * EYE_SIZE_RATE * 0.5f,
                                                                        faceWidth * EYE_SIZE_RATE, faceWidth * EYE_SIZE_RATE )];
        rightEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        rightEyeView.layer.cornerRadius = faceWidth * EYE_SIZE_RATE * 0.5;
        [self drawFeature:rightEyeView];
    }
    
    //Draw Mouth
    if( face.hasMouth )
    {
        CGPoint imageMouthPosition = CGPointFromString( face.mouthPoint );
        const CGPoint mouthPos = CGPointApplyAffineTransform( [self.iboImageView convertPointFromImage:imageMouthPosition], transform );
        UIView* mouthView = [[UIView alloc] initWithFrame:CGRectMake( mouthPos.x - faceWidth * MOUTH_SIZE_RATE * 0.5f, mouthPos.y - faceWidth * MOUTH_SIZE_RATE * 0.5f,
                                                                     faceWidth * MOUTH_SIZE_RATE, faceWidth * MOUTH_SIZE_RATE)];
        mouthView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3f];
        mouthView.layer.cornerRadius = faceWidth * MOUTH_SIZE_RATE * 0.5f;
        [self drawFeature:mouthView];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  drawFeature:                                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)drawFeature:(UIView*)view
{
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_async( mainQueue, ^
//                   {
//                       [self.iboImageView addSubview:view];
//                   });
    [self.iboImageView addSubview:view];
}

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
                [self drawFaces];
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
	
    if( features.count != 0 )
    {
        for( CIFaceFeature* faceFeature in features )
        {
            JMFFace* face = [JMFFace faceWithName:@"Face Feature" feature:faceFeature inContext:fetchResultsController.managedObjectContext];
        }
    }
    
    if( completionBlock ) completionBlock( features.count != 0 );
}

@end