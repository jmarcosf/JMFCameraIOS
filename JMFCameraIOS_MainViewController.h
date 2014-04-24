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
#import "JMFArrayViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController : JMFArrayViewController <UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                                                     UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(NSMutableArray*)model;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)redrawControls:(BOOL)bOnlyButtons;
- (void)editPhoto;

- (void)onCameraClicked;
- (void)onModeClicked;
- (void)onDeleteClicked;
- (void)onFlickrClicked;

@end
