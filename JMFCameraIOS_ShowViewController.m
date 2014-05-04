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
    CGRect          previousFrame;
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
    self.title = NSLocalizedString( @"IDS_SHOW", nil );
    
    self.iboScrollView.minimumZoomScale = 1.0;
    self.iboScrollView.maximumZoomScale = 6.0;
    self.iboScrollView.contentMode = UIViewContentModeScaleAspectFit;
    self.iboScrollView.clipsToBounds = YES;
    self.iboScrollView.delegate = self;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 320, 416 ) ];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    self.iboZoomableView.contentMode = UIViewContentModeScaleAspectFit;
    self.iboZoomableView.clipsToBounds = YES;
    [self.iboZoomableView addSubview:imageView];
    bFullScreen = NO;
    
    UITapGestureRecognizer* tapRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector( onPictureClicked: )];
    [self.iboZoomableView addGestureRecognizer:tapRecognizer];
    [tapRecognizer setDelegate:self];
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
    if( !bFullScreen )
    {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^
        {
             previousFrame = imageView.frame;
             [self.iboScrollView setFrame:[[UIScreen mainScreen] bounds]];
        } completion:^( BOOL finished ) { bFullScreen = YES; } ];
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^
        {
            [imageView setFrame:previousFrame];
        } completion:^( BOOL finished ) {bFullScreen = NO; } ];
    }
}

@end