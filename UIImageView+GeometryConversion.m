/***************************************************************************/
/*                                                                         */
/*  UIImageView+GeometryConversion.m                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIAlertView Category Class implementation file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: From Dominique d'Argent & Thomas Sarlandie GitHub project */
/*                                                                         */
/***************************************************************************/
#import "UIImageView+GeometryConversion.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIImageView+GeometryConversion Class Implemantation                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation UIImageView (GeometryConversion)

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
/*  convertPointFromImage:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGPoint)convertPointFromImage:(CGPoint)imagePoint
{
    CGPoint             viewPoint     = imagePoint;
    CGSize              imageSize     = self.image.size;
    CGSize              viewSize      = self.bounds.size;
    CGFloat             ratioX        = viewSize.width / imageSize.width;
    CGFloat             ratioY        = viewSize.height / imageSize.height;
    CGFloat             scale         = 0;
    UIViewContentMode   contentMode   = self.contentMode;
    
    switch( contentMode )
    {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
            viewPoint.x *= ratioX;
            viewPoint.y *= ratioY;
            break;
            
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
            scale = ( contentMode == UIViewContentModeScaleAspectFit ) ? scale = MIN( ratioX, ratioY ) : MAX( ratioX, ratioY );
            viewPoint.x *= scale;
            viewPoint.y *= scale;
            viewPoint.x += ( viewSize.width  - imageSize.width  * scale ) / 2.0f;
            viewPoint.y += ( viewSize.height - imageSize.height * scale ) / 2.0f;
            break;
            
        case UIViewContentModeCenter:
            viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0f;
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            break;
            
        case UIViewContentModeTop:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0f;
            break;
            
        case UIViewContentModeBottom:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0f;
            viewPoint.y += viewSize.height - imageSize.height;
            break;
            
        case UIViewContentModeLeft:
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            break;
            
        case UIViewContentModeRight:
            viewPoint.x += viewSize.width - imageSize.width;
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            break;
            
        case UIViewContentModeTopRight:
            viewPoint.x += viewSize.width - imageSize.width;
            break;
            
        case UIViewContentModeBottomLeft:
            viewPoint.y += viewSize.height - imageSize.height;
            break;
            
        case UIViewContentModeBottomRight:
            viewPoint.x += viewSize.width  - imageSize.width;
            viewPoint.y += viewSize.height - imageSize.height;
            break;
            
        case UIViewContentModeTopLeft:
        default:
            break;
    }
    
    return viewPoint;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  convertRectFromImage:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGRect)convertRectFromImage:(CGRect)imageRect
{
    CGPoint imageTopLeft     = imageRect.origin;
    CGPoint imageBottomRight = CGPointMake( CGRectGetMaxX( imageRect ), CGRectGetMaxY( imageRect ) );
    CGPoint viewTopLeft      = [self convertPointFromImage:imageTopLeft];
    CGPoint viewBottomRight  = [self convertPointFromImage:imageBottomRight];
    
    CGRect viewRect;
    viewRect.origin = viewTopLeft;
    viewRect.size   = CGSizeMake( ABS( viewBottomRight.x - viewTopLeft.x ), ABS( viewBottomRight.y - viewTopLeft.y ) );
    
    return viewRect;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  convertPointFromView:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGPoint)convertPointFromView:(CGPoint)viewPoint
{
    CGPoint             imagePoint  = viewPoint;
    CGSize              imageSize   = self.image.size;
    CGSize              viewSize    = self.bounds.size;
    CGFloat             ratioX      = viewSize.width / imageSize.width;
    CGFloat             ratioY      = viewSize.height / imageSize.height;
    CGFloat             scale       = 0;
    UIViewContentMode   contentMode = self.contentMode;
    
    switch( contentMode )
    {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
            imagePoint.x /= ratioX;
            imagePoint.y /= ratioY;
            break;
            
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
            scale = ( contentMode == UIViewContentModeScaleAspectFit ) ? MIN( ratioX, ratioY ) : MAX( ratioX, ratioY );
            imagePoint.x -= ( viewSize.width  - imageSize.width  * scale ) / 2.0f;
            imagePoint.y -= ( viewSize.height - imageSize.height * scale ) / 2.0f;
            imagePoint.x /= scale;
            imagePoint.y /= scale;
            break;
            
        case UIViewContentModeCenter:
            imagePoint.x -= ( viewSize.width - imageSize.width )  / 2.0f;
            imagePoint.y -= ( viewSize.height - imageSize.height ) / 2.0f;
            break;
            
        case UIViewContentModeTop:
            imagePoint.x -= ( viewSize.width - imageSize.width )  / 2.0f;
            break;
            
        case UIViewContentModeBottom:
            imagePoint.x -= ( viewSize.width - imageSize.width )  / 2.0f;
            imagePoint.y -= ( viewSize.height - imageSize.height );
            break;
            
        case UIViewContentModeLeft:
            imagePoint.y -= ( viewSize.height - imageSize.height ) / 2.0f;
            break;
            
        case UIViewContentModeRight:
            imagePoint.x -= ( viewSize.width - imageSize.width );
            imagePoint.y -= ( viewSize.height - imageSize.height ) / 2.0f;
           break;
            
        case UIViewContentModeTopRight:
            imagePoint.x -= ( viewSize.width - imageSize.width );
            break;
            
        case UIViewContentModeBottomLeft:
            imagePoint.y -= ( viewSize.height - imageSize.height );
            break;
            
        case UIViewContentModeBottomRight:
            imagePoint.x -= ( viewSize.width - imageSize.width );
            imagePoint.y -= ( viewSize.height - imageSize.height );
            break;
            
        case UIViewContentModeTopLeft:
        default:
            break;
    }
    
    return imagePoint;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  convertRectFromView:                                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGRect)convertRectFromView:(CGRect)viewRect
{
    CGPoint viewTopLeft         = viewRect.origin;
    CGPoint viewBottomRight     = CGPointMake( CGRectGetMaxX( viewRect ), CGRectGetMaxY( viewRect ) );
    CGPoint imageTopLeft        = [self convertPointFromView:viewTopLeft];
    CGPoint imageBottomRight    = [self convertPointFromView:viewBottomRight];
    
    CGRect imageRect;
    imageRect.origin = imageTopLeft;
    imageRect.size = CGSizeMake( ABS( imageBottomRight.x - imageTopLeft.x ), ABS( imageBottomRight.y - imageTopLeft.y ) );
    
    return imageRect;
}

@end
