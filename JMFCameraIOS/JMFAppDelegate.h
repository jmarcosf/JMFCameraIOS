/***************************************************************************/
/*                                                                         */
/*  JMFAppDelegate.h                                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               App Delegate Class definition File                        */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Class forwarding                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class JMFCoreDataStack;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFAppDelegate Class Interface                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFAppDelegate : UIResponder <UIApplicationDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (strong, nonatomic) UIWindow*             window;
@property (strong, nonatomic) JMFCoreDataStack*     model;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)performCoreDataAutoSave;
- (void)onManageObjectsChanged:(NSNotification*)notification;

@end
