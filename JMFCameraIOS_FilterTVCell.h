/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FilterTVCell.h                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filter Table View Cell Class definition file              */
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
@class JMFCameraIOS_FilterTVCell;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterTVCell Protocol definition                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@protocol JMFCameraIOS_FilterTVCellDelegate< NSObject >

@optional
- (void)filterCell:(JMFCameraIOS_FilterTVCell*)filterCell forIndexPath:(NSIndexPath*)indexPath didChangeState:(BOOL)newState;
- (void)filterCell:(JMFCameraIOS_FilterTVCell*)filterCell onPropertiesClickedforIndexPath:(NSIndexPath*)indexPath;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterTVCell Class Interface                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FilterTVCell : UITableViewCell

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) NSIndexPath*   indexPath;
@property (nonatomic,assign) id< JMFCameraIOS_FilterTVCellDelegate > delegate;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*   iboImageView;
@property (weak, nonatomic) IBOutlet UIButton*      iboPropertiesButton;
@property (weak, nonatomic) IBOutlet UILabel*       iboNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch*      iboActiveSwitch;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onSwitchChanged:(id)sender;
- (IBAction)onPropertiesClicked:(id)sender;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Class Instance Methods                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)startMove;
- (void)endMove;

@end

