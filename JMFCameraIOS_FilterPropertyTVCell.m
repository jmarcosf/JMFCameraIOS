/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FilterPropertyTVCell.m                                    */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filter Property TableView Cell Class implementation file  */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FilterPropertyTVCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterPropertyTVCell Class Implementation                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FilterPropertyTVCell

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

#pragma mark - IBAction Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  IBAction Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onPropertyValueChanged:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onPropertyValueChanged:(id)sender
{
    CGFloat value = [self.iboPropertyValue.text floatValue];
    self.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", value];
    
    if( [ self.delegate respondsToSelector:@selector( filterPropertyCell:didChangeValue:forIndexPath: )] )
    {
        [self.delegate filterPropertyCell:self didChangeValue:value forIndexPath:self.indexPath];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onSpinValueChanged:                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onSpinValueChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    CGFloat value = [self.iboPropertyValue.text floatValue];
    
    if( segmentedControl.selectedSegmentIndex == 0 )
    {
        if( [ self.delegate respondsToSelector:@selector( filterPropertyCell:shouldIncrementValue:forIndexPath: )] )
        {
            [self.delegate filterPropertyCell:self shouldIncrementValue:value forIndexPath:self.indexPath];
        }
    }
    else
    {
        if( [ self.delegate respondsToSelector:@selector( filterPropertyCell:shouldDecrementValue:forIndexPath: )] )
        {
            [self.delegate filterPropertyCell:self shouldDecrementValue:value forIndexPath:self.indexPath];
        }
    }
}

@end
