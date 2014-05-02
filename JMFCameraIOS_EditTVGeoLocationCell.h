/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_EditTVGeoLocationCell.h                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Edit TableView Photo GeoLocation Cell definition file     */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditTVGeoLocationCell Class Interface                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_EditTVGeoLocationCell : UITableViewCell

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UILabel*   iboDataTitle;
@property (weak, nonatomic) IBOutlet UILabel*   iboDataValue;


/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
