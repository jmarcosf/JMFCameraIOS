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
#import "JMFCoreDataStack.h"
#import "JMFPhoto.h"

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
@property (nonatomic,strong) JMFCoreDataStack*      model;
@property (nonatomic,strong) JMFPhoto*              photo;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*   iboSourceImageView;
@property (weak, nonatomic) IBOutlet UILabel*       iboFullScreenLabel;
@property (weak, nonatomic) IBOutlet UITableView*   iboTableView;
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;
@property (weak, nonatomic) IBOutlet UILabel*       iboNameTitle;
@property (weak, nonatomic) IBOutlet UILabel*       iboNameValue;
@property (weak, nonatomic) IBOutlet UILabel*       iboCreatedTitle;
@property (weak, nonatomic) IBOutlet UILabel*       iboCreatedValue;
@property (weak, nonatomic) IBOutlet UILabel*       iboModifiedTitle;
@property (weak, nonatomic) IBOutlet UILabel*       iboModifiedValue;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo inModel:(JMFCoreDataStack*)model;
- (void)onShareClicked;
- (void)onFaceDetectionClicked;
- (void)onFiltersClicked;

@end
