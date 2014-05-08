/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FilterPropertyTVCell.h                                    */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filter Property TableView Cell Class definition file      */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>


/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class forwarding                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class JMFCameraIOS_FilterPropertyTVCell;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterPropertyTVCell Protocol definition                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@protocol JMFCameraIOS_FilterPropertyTVCellDelegate< NSObject >

@optional
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell*)filterPropertyCell didChangeValue:(CGFloat)newValue forIndexPath:(NSIndexPath*)indexPath;
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell*)filterPropertyCell shouldIncrementValue:(CGFloat)value forIndexPath:(NSIndexPath*)indexPath;
- (void)filterPropertyCell:(JMFCameraIOS_FilterPropertyTVCell*)filterPropertyCell shouldDecrementValue:(CGFloat)value forIndexPath:(NSIndexPath*)indexPath;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterPropertyTVCell Class Interface                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FilterPropertyTVCell : UITableViewCell


/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) NSIndexPath*   indexPath;
@property (nonatomic,assign) id< JMFCameraIOS_FilterPropertyTVCellDelegate >    delegate;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UILabel*               iboPropertyName;
@property (weak, nonatomic) IBOutlet UITextField*           iboPropertyValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl*    iboSpinView;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onPropertyValueChanged:(id)sender;
- (IBAction)onSpinValueChanged:(id)sender;

@end

