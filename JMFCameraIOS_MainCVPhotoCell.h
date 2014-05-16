/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainCVPhotoCell.h                                         */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main CollectionView Photo Cell Class definition file      */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainCVPhotoCell Class Interface                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_MainCVPhotoCell : UICollectionViewCell

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic)   BOOL    bImageOK;
@property (nonatomic)   BOOL    bUploading;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIImageView*       iboPhotoImage;
@property (weak, nonatomic) IBOutlet UIImageView*       iboSelectedIcon;
@property (weak, nonatomic) IBOutlet UIImageView*       iboSynchronizedIcon;
@property (weak, nonatomic) IBOutlet UIProgressView*    iboSyncProgress;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setSelected:(BOOL)selected;

@end
