/***************************************************************************/
/*                                                                         */
/*  UIImageView+GeometryConversion.h                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIAlertView Category Class definition file                */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: From Dominique d'Argent & Thomas Sarlandie GitHub project */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIImageView+GeometryConversion Class Interface                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface UIImageView( GeometryConversion )

- (CGPoint)convertPointFromImage:(CGPoint)imagePoint;
- (CGRect)convertRectFromImage:(CGRect)imageRect;
- (CGPoint)convertPointFromView:(CGPoint)viewPoint;
- (CGRect)convertRectFromView:(CGRect)viewRect;

@end
