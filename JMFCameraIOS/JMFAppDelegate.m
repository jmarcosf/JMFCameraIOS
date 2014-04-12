/***************************************************************************/
/*                                                                         */
/*  JMFAppDelegate.m                                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               App Delegate Class implementation File                    */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFAppDelegate.h"
#import "JMFCameraIOS_MainViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFAppDelegate Class Implementation                                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFAppDelegate

#pragma mark - UIApplicationDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIApplicationDelegate Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  application:didFinishLaunchingWithOptions:                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    JMFCameraIOS_MainViewController* mainVC = [[JMFCameraIOS_MainViewController alloc]init];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationWillResignActive:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDidEnterBackground:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationWillEnterForeground:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDidBecomeActive:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationWillTerminate:                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
