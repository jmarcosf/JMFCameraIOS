/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainViewController.h                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main View Controller Class definition file                */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController : UIViewController

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UILabel*       iboEmptyAlbumLabel;
@property (weak, nonatomic) IBOutlet UIToolbar*     iboToolbar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onCameraClicked:(id)sender;
- (IBAction)onModeClicked:(id)sender;
- (IBAction)onEditClicked:(id)sender;
- (IBAction)onDeleteClicked:(id)sender;
- (IBAction)onFlickrClicked:(id)sender;

@end
