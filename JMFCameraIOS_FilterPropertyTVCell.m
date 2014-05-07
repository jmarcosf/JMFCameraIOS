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
    if( segmentedControl.selectedSegmentIndex == 0 ) value += 0.10;
    else value -= 0.10;
    if( value < 0 ) value = 0.0;
    if( value > 100.0 ) value = 100.0;
    self.iboPropertyValue.text = [NSString stringWithFormat: @"%.2f", value];
    
    if( [ self.delegate respondsToSelector:@selector( filterPropertyCell:didChangeValue:forIndexPath: )] )
    {
        [self.delegate filterPropertyCell:self didChangeValue:value forIndexPath:self.indexPath];
    }
}

@end
