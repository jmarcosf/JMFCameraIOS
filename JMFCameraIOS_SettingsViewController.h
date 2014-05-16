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
#import "JMFFlickr.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_SettingsViewController : UIViewController <JMFFlickrOAuthDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel*                   iboFlickrSyncTitle;
@property (weak, nonatomic) IBOutlet UIView*                    iboFlickrSyncContainer;
@property (weak, nonatomic) IBOutlet UILabel*                   iboFlickrSyncLabel;
@property (weak, nonatomic) IBOutlet UISwitch*                  iboFlickrSyncSwitch;
@property (weak, nonatomic) IBOutlet UIView*                    iboIntervalContainer;
@property (weak, nonatomic) IBOutlet UILabel*                   iboIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel*                   iboIntervalValue;
@property (weak, nonatomic) IBOutlet UIStepper*                 iboIntervalSetepper;
@property (weak, nonatomic) IBOutlet UILabel*                   iboDatabaseTitle;
@property (weak, nonatomic) IBOutlet UIView*                    iboDropContainer;
@property (weak, nonatomic) IBOutlet UILabel*                   iboDropLabel;
@property (weak, nonatomic) IBOutlet UISwitch*                  iboDropSwitch;
@property (weak, nonatomic) IBOutlet UIWebView*                 iboWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   iboActivityIndicator;

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
- (IBAction)onIntervalValueChanged:(id)sender;
- (IBAction)onDropDatabaseChanged:(id)sender;


@end
