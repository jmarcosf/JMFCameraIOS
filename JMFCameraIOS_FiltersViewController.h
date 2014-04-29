/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController.h                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filters View Controller Class definition file             */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>
#import "JMFPhoto.h"
#import "JMFFilter.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FiltersViewController : UIViewController <UITabBarDelegate, NSFetchedResultsControllerDelegate,
                                                                  UITableViewDataSource, UITableViewDelegate,
                                                                  UIPickerViewDataSource, UIPickerViewDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) JMFCoreDataStack*      model;
@property (nonatomic,strong) JMFPhoto*              photo;
@property (nonatomic,strong) UIImage*               image;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*   iboSourceImage;
@property (weak, nonatomic) IBOutlet UIImageView*   iboTargetImage;
@property (weak, nonatomic) IBOutlet UITableView*   iboFilterTable;
@property (weak, nonatomic) IBOutlet UITabBar*      iboTabBar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image inModel:(JMFCoreDataStack*)model;
- (void)enableButtons;
- (void)addFilter:(id)sender;
- (void)onCancelClicked;
- (void)onClearClicked;
- (void)onApplyClicked;
- (void)onSaveClicked;
- (void)onSwitchChanged:(id)sender;

@end
