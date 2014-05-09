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
#import "JMFCameraIOS_FilterTVCell.h"
#import "JMFCameraIOS_FilterTVPickerCell.h"
#import "JMFCameraIOS_FilterPropertyTVCell.h"
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
                                                                  UIPickerViewDataSource, UIPickerViewDelegate,
                                                                  JMFCameraIOS_FilterTVCellDelegate,
                                                                  JMFCameraIOS_FilterPropertyTVCellDelegate,
                                                                  UITextFieldDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) JMFCoreDataStack*                  model;
@property (nonatomic,strong) JMFPhoto*                          photo;
@property (nonatomic,strong) UIImage*                           image;
@property (nonatomic,strong) UITableView*                       iboFilterTable;
@property (nonatomic,strong) UITableView*                       iboPropertyTable;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   iboActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView*               iboSourceImage;
@property (weak, nonatomic) IBOutlet UIImageView*               iboTargetImage;
@property (weak, nonatomic) IBOutlet UITabBar*                  iboTabBar;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithPhoto:(JMFPhoto*)photo andImage:(UIImage*)image inModel:(JMFCoreDataStack*)model;
- (void)setupFilterList;
- (void)enableButtons;
- (void)onAddFilterClicked:(id)sender;
- (void)onEditClicked:(id)sender;
- (void)onCancelClicked;
- (void)onBackClicked;
- (void)onClearClicked;
- (void)onApplyClicked;
- (void)onSaveClicked;
- (void)setTargetImage;
- (JMFFilter*)getSelectedFilter;

@end
