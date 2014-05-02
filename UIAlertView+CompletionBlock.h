/***************************************************************************/
/*                                                                         */
/*  UIAlertView+CompletionBlock.h                                          */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIAlertView Category Class definition file                */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Adapted from www.nscookbook.com recipe #22                */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIAlertView+CompletionBlock Class Interface                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface UIAlertView( CompletionBlock )

- (void)showWithCompletion:(void(^)( UIAlertView* alertView, NSInteger buttonIndex ))completion;
- (void)showWithActivityIndicatorWithColor:(UIColor*)color;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSCBAlertWrapper Class Interface                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface NSCBAlertWrapper : NSObject

@property (copy) void(^completionBlock)( UIAlertView* alertView, NSInteger buttonIndex );

@end