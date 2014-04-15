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
@interface JMFCameraIOS_MainViewController : UIViewController <UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)redrawControls:(BOOL)bOnlyButtons;
- (void)reloadData;
- (void)onCameraClicked;
- (void)onModeClicked;
- (void)onEditClicked;
- (void)onDeleteClicked;
- (void)onFlickrClicked;

@end
