/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainCVPhotoCell.m                                         */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main CollectionView Photo Cell Class implementation file  */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_MainCVPhotoCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainCVPhotoCell Class Implementation                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_MainCVPhotoCell

#pragma mark - UIView Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIView Override Methods                                                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithFrame:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.iboSyncProgress.progress = 0.0;
        self.iboSyncProgress.hidden = YES;
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setSelected:                                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UICollectionView* collectionView = (UICollectionView*)[self superview];
    if( [collectionView isKindOfClass:[UICollectionView class]] && collectionView.allowsMultipleSelection )
    {
        self.iboSelectedIcon.hidden = !selected;
    }
}

@end

