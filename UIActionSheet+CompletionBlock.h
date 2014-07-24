/***************************************************************************/
/*                                                                         */
/*  UIActionSheet+CompletionBlock.h                                        */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIActionSheet Category Class definition file              */
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
/*  UIActionSheet+CompletionBlock Class Interface                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface UIActionSheet( CompletionBlock )

- (void)showFromToolbar:(UIToolbar*)toolbar withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ) )completion;
- (void)showFromTabBar:(UITabBar*)tabBar withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ) )completion;
- (void)showFromBarButtonItem:(UIBarButtonItem*)button animated:(BOOL)animated withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ) )completion;
- (void)showFromRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ) )completion;
- (void)showInView:(UIView*)view withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ) )completion;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFActionWrapper Class Interface                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFActionWrapper : NSObject <UIActionSheetDelegate>

@property (copy) void(^completionBlock)( UIActionSheet* alertView, NSInteger buttonIndex );

@end