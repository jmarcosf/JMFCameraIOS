/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController.h                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Face Recognition View Controller Class definition file    */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FaceRecViewController : UIViewController

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
@property (weak, nonatomic) IBOutlet UIImageView*               iboImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   iboActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel*                   iboFaceLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel*                   iboLeftEyeLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel*                   iboRightEyeLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel*                   iboMouthLabelTitle;

@property (weak, nonatomic) IBOutlet UILabel*                   iboFaceLabel;
@property (weak, nonatomic) IBOutlet UILabel*                   iboLeftEyeLabel;
@property (weak, nonatomic) IBOutlet UILabel*                   iboRightEyeLabel;
@property (weak, nonatomic) IBOutlet UILabel*                   iboMouthLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem*           iboDetectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem*           iboClearButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem*           iboCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem*           iboApplyButton;


/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithImage:(UIImage*)image;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onDetect:(id)sender;
- (IBAction)onClear:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onApply:(id)sender;

@end
