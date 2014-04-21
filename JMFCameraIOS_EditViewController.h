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
@interface JMFCameraIOS_EditViewController : UIViewController <UITabBarDelegate>

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
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;
@property (weak, nonatomic) IBOutlet UIImageView*   iboSourceImage;
@property (weak, nonatomic) IBOutlet UIImageView*   iboTargetImage;
@property (weak, nonatomic) IBOutlet UILabel*       iboFilter1Label;
@property (weak, nonatomic) IBOutlet UILabel*       iboFilter2Label;
@property (weak, nonatomic) IBOutlet UILabel*       iboFilter3Label;
@property (weak, nonatomic) IBOutlet UILabel*       iboFilter4Label;
@property (weak, nonatomic) IBOutlet UILabel*       iboFilter5Label;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFilter1Switch;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFilter2Switch;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFilter3Switch;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFilter4Switch;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFilter5Switch;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithImage:(UIImage*)image;
- (void)onShareClicked;
- (void)onShowClicked;
- (void)onFiltersClicked;
- (void)onDataClicked;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onFilterSwitchChanged:(id)sender;


@end
