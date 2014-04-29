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

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDC_UITOOLBAR_BUTTON_CLEAR_INDEX            0
#define IDC_UITOOLBAR_BUTTON_DETECT_INDEX           1
#define IDC_UITOOLBAR_BUTTON_SAVE_INDEX             2

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
    NSFetchedResultsController*     fetchedResultsController;
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
/*  initWithPhoto:andImage:inModel:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image inModel:(JMFCoreDataStack *)model
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
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = NSLocalizedString( @"IDS_FACE_DETECTION", nil );
    if( self.image == nil ) self.image = [UIImage imageWithContentsOfFile:self.photo.sourceImageUrl];
    self.iboImageView.image = self.image;
    
    //TabBar
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setTitle:NSLocalizedString( @"IDS_CLEAR", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setTitle:NSLocalizedString( @"IDS_DETECT", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setTitle:NSLocalizedString( @"IDS_SAVE", nil )];

    //Query
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[JMFFace entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMFNamedEntityAttributes.name ascending:YES selector:@selector( caseInsensitiveCompare: )]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo ];
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.model.context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    fetchedResultsController.delegate = self;
    NSError *error;
    [fetchedResultsController performFetch:&error];
    if( !error ) [self drawFaces];
    else if( APPDEBUG ) NSLog( @"Fetch Faces error: %@", error );
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
    
    int count = [[fetchedResultsController fetchedObjects]count];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX]  setEnabled:( count > 0 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( count <= 0 )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SAVE_INDEX]   setEnabled:( YES )];
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
        case IDC_UITOOLBAR_BUTTON_CLEAR_INDEX:  [self onClearClicked];  break;
        case IDC_UITOOLBAR_BUTTON_DETECT_INDEX: [self onDetectClicked]; break;
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
/*  controllerDidChangeContent:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self drawFaces];
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
    int count = [[fetchedResultsController fetchedObjects]count];;
    for( int i = 0; i < count; i++ )
    {
        JMFFace* face = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async( mainQueue, ^
        {
            [self drawFace:face];
        });
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
    [self.iboImageView addSubview:faceView];
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
        [self.iboImageView addSubview:leftEyeView];
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
        [self.iboImageView addSubview:rightEyeView];
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
        [self.iboImageView addSubview:mouthView];
    }
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
                [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX] setEnabled:( bDetected )];
                [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( !bDetected )];
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
    
    fetchedResultsController.delegate = nil;
    for( JMFFace* face in [fetchedResultsController fetchedObjects] ) [self.model.context deleteObject:face];
    [self.model saveWithErrorBlock:nil];
    fetchedResultsController.delegate = self;

    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CLEAR_INDEX] setEnabled:( NO )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DETECT_INDEX] setEnabled:( YES )];
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
        int i = 0;
        for( CIFaceFeature* faceFeature in features )
        {
            JMFFace* face = [JMFFace faceWithName:@"Face Feature" feature:faceFeature photo:self.photo inContext:self.model.context];
            face.name = [NSString stringWithFormat:@"%@ #%d", NSLocalizedString( @"IDS_FACE", nil ), ++i];
        }
        [self.model saveWithErrorBlock:nil];
    }
    
    if( completionBlock ) completionBlock( features.count != 0 );
}

@end