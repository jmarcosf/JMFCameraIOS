/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_ShowViewController.m                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Show View Controller Class implementation file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_ShowViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_ShowViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_ShowViewController ()
{
    UIImageView*    imageView;
    BOOL            bFullScreen;
    CGRect          originalFrame;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_ShowViewController Class Implemantation                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_ShowViewController

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
/*  viewDidLoad                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.title = ResString( @"IDS_SHOW" );
    
    self.iboScrollView.minimumZoomScale = 1.0;
    self.iboScrollView.maximumZoomScale = 6.0;
    self.iboScrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.iboScrollView.delegate = self;
    
    self.iboZoomableView.contentMode = UIViewContentModeScaleAspectFill;

    imageView = [[UIImageView alloc]init];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.iboZoomableView addSubview:imageView];
    
    bFullScreen = NO;
    originalFrame = self.view.frame;
    [self adjustViews];
    
    UITapGestureRecognizer* tapRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector( onPictureClicked: )];
    [self.iboZoomableView addGestureRecognizer:tapRecognizer];
    [tapRecognizer setDelegate:self];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  prefersStatusBarHidden                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)prefersStatusBarHidden
{
    return bFullScreen;
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

#pragma mark - UIScrollViewDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIScrollViewDelegate Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewForZoomingInScrollView:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return self.iboZoomableView;
}

#pragma mark - UIGestureRecognizerDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIGestureRecognizerDelegate Methods                                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onPictureClicked:                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onPictureClicked:(UITapGestureRecognizer*)tapRecognizer
{
    [UIView animateWithDuration:0.5 animations:^
    {
        bFullScreen = !bFullScreen;
        [self adjustViews];
    }];
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
/*  adjustViews                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)adjustViews
{
    [[self navigationController] setNavigationBarHidden:bFullScreen animated:bFullScreen];
    CGRect Rect = ( bFullScreen ) ? [[UIScreen mainScreen]bounds] : originalFrame;
    self.view.frame = Rect;
    self.iboScrollView.frame = Rect;
    self.iboZoomableView.frame = Rect;
    imageView.frame = Rect;
}

@end