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
#import "JMFPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FaceRecViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FaceRecViewController : UIViewController <UITabBarDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) JMFPhoto*  photo;
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
@property (weak, nonatomic) IBOutlet UITabBar*                  iboTabBar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image;
- (void)drawFaces;
- (void)drawFace:(JMFFace*)face;
- (void)drawFeature:(UIView*)view;
- (void)onDetectClicked;
- (void)onClearClicked;
- (void)onCancelClicked;
- (void)onApplyClicked;

@end
