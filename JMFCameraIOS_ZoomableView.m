/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_ZoomableView.m                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               ZoomableView Class implementation file                    */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_ZoomableView.h"
#import <QuartzCore/QuartzCore.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_ZoomableView Class Implementation                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_ZoomableView

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (Class)layerClass
{
    return [CATiledLayer class]; // Set the UIView layer to CATiledLayer
}

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
    if( self = [super initWithFrame:frame] )
    {
        CATiledLayer* tempTiledLayer = (CATiledLayer*)self.layer;
        tempTiledLayer.levelsOfDetail = 5;
        tempTiledLayer.levelsOfDetailBias = 2;
        self.opaque = YES;
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  drawRect:                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)drawRect:(CGRect)rect
{
}

@end

