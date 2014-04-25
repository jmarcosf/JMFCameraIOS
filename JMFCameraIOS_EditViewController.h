/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_EditViewController.h                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Edit View Controller Class definition file                */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_EditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) UIImage*   image;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*   iboSourceImageView;
@property (weak, nonatomic) IBOutlet UIImageView*   iboFilteredImageView;
@property (weak, nonatomic) IBOutlet UITableView*   iboTableView;
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;
@property (weak, nonatomic) IBOutlet UILabel*       iboFullScreenLabel;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithImage:(UIImage*)image;
- (void)onShareClicked;
- (void)onFaceDetectionClicked;
- (void)onFiltersClicked;

@end
