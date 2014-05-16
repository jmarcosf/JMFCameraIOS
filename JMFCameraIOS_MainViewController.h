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
#import "JMFCoreDataViewController.h"
#import "JMFNamedEntity.h"
#import "JMFPhoto.h"
#import "JMFFlickrSync.h"
@import CoreLocation;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainViewController Class Interface                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainViewController : JMFCoreDataViewController <UITabBarDelegate, CLLocationManagerDelegate,
                                                                        UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                                                        UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate,
                                                                        JMFFlickrSyncDelegate>

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
@property (weak, nonatomic) IBOutlet UITabBar*                  iboTabBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   iboActivityIndicator;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(JMFCoreDataStack*)model;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)redrawControls:(BOOL)bOnlyButtons;
- (void)scrollToBottom;
- (void)animateModeChange;
- (void)editPhoto;
- (void)onSettingsClicked:(id)sender;
- (void)onSelectClicked:(id)sender;
- (void)onCameraClicked;
- (void)onModeClicked;
- (void)onDeleteClicked;
- (void)onFlickrClicked;
- (void)onAlbumClicked;
- (void)onSyncClicked;
@end
