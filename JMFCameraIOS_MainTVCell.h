/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainTVCell.h                                              */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main TableView Cell Class definition file                 */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainTVCell Class Interface                                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainTVCell : UITableViewCell

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*       iboImageView;
@property (weak, nonatomic) IBOutlet UILabel*           iboNameLabel;
@property (weak, nonatomic) IBOutlet UILabel*           iboSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel*           iboSourceTitle;
@property (weak, nonatomic) IBOutlet UILabel*           iboSourceValue;
@property (weak, nonatomic) IBOutlet UILabel*           iboWhenTitle;
@property (weak, nonatomic) IBOutlet UILabel*           iboWhenValue;
@property (weak, nonatomic) IBOutlet UILabel*           iboWhereTitle;
@property (weak, nonatomic) IBOutlet UILabel*           iboWhereValue;
@property (weak, nonatomic) IBOutlet UIImageView*       iboSynchronizedIcon;
@property (weak, nonatomic) IBOutlet UIProgressView*    iboSyncProgress;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
