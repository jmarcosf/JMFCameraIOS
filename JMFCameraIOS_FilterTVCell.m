/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FilterTVCell.m                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filter Table View Cell Class implementation file          */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FilterTVCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FilterTVCell Class Implementation                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FilterTVCell

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
/*  onSwitchChanged:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onSwitchChanged:(id)sender
{
    if( [ self.delegate respondsToSelector:@selector( filterCell:forIndexPath:didChangeState: )] )
    {
        [self.delegate filterCell:self forIndexPath:self.indexPath didChangeState:self.iboActiveSwitch.on];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onpropertiesClicked:                                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onPropertiesClicked:(id)sender
{
    if( [ self.delegate respondsToSelector:@selector( filterCell:onPropertiesClickedforIndexPath: )] )
    {
        [self.delegate filterCell:self onPropertiesClickedforIndexPath:self.indexPath];
    }
}

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  startMove                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)startMove
{
    self.iboImageView.hidden = YES;
    self.iboPropertiesButton.hidden = YES;
    self.iboActiveSwitch.hidden = YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  endMove                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)endMove
{
    self.iboImageView.hidden = NO;
    self.iboPropertiesButton.hidden = NO;
    self.iboActiveSwitch.hidden = NO;
}

@end
