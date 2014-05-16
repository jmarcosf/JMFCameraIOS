/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MainTVCell.m                                              */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Main TableView Cell Class implementation file             */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_MainTVCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MainTVCell Class Implementation                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_MainTVCell

#pragma mark - UITableViewCell Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewCell Override Methods                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithStyle:reuseIdentifier:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self )
    {
        self.iboSyncProgress.progress = 0.0;
        self.iboSyncProgress.hidden = YES;
        self.bUploading = NO;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  layoutSubviews                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = CGRectMake( 1, 1, self.frame.size.height - 1, self.frame.size.height - 1 );
    self.imageView.clipsToBounds = YES;
}

@end
