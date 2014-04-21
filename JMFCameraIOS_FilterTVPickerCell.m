/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FilterTVPickerCell.m                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filter Table View Picker Cell Class implementation file   */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FilterTVPickerCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterTVPickerCell Class Implementation                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FilterTVPickerCell

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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self )
    {
        self.cellContainer = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, self.contentView.frame.size.width, 150 )];
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake( 2, 2, self.contentView.frame.size.width - 2, 148 )];
        [self.cellContainer addSubview:self.pickerView];
        [self.contentView addSubview:self.cellContainer];
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

@end
