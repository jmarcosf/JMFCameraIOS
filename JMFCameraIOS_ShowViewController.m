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
    self.iboScrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.iboScrollView.delegate = self;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 320, 416 ) ];
    imageView.image = self.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iboZoomableView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iboZoomableView addSubview:imageView];
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

@end