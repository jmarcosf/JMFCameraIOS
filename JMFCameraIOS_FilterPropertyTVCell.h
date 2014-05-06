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
- (IBAction)onSpinButtonClicked:(id)sender;

@end

