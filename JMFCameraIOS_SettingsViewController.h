/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController.h                                  */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Settings View Controller Class definition file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_SettingsViewController : UIViewController

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) JMFCoreDataStack*      model;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UILabel*       iboFlickrSyncTitle;
@property (weak, nonatomic) IBOutlet UIView*        iboFlickrSyncContainer;
@property (weak, nonatomic) IBOutlet UILabel*       iboFlickrSyncLabel;
@property (weak, nonatomic) IBOutlet UISwitch*      iboFlickrsyncSwitch;
@property (weak, nonatomic) IBOutlet UIView*        iboFrequencyContainer;
@property (weak, nonatomic) IBOutlet UILabel*       iboFrequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel*       iboFrequencyValue;
@property (weak, nonatomic) IBOutlet UIStepper*     iboFrequencySetepper;
@property (weak, nonatomic) IBOutlet UILabel*       iboDatabaseTitle;
@property (weak, nonatomic) IBOutlet UIView*        iboDropContainer;
@property (weak, nonatomic) IBOutlet UILabel*       iboDropLabel;
@property (weak, nonatomic) IBOutlet UISwitch*      iboDropSwitch;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(JMFCoreDataStack*)model;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onSyncPicturesChanged:(id)sender;
- (IBAction)onFrequencyValueChanged:(id)sender;
- (IBAction)onDropDatabaseChanged:(id)sender;


@end
