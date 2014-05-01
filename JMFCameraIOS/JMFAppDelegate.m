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
#import "JMFUtility.h"
#import "JMFCoreDataStack.h"
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
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if( ![JMFUtility createApplicationDirectories] )
    {
        NSString* IDS_OK      = NSLocalizedString( @"IDS_OK", nil );
        NSString* IDS_MESSAGE = NSLocalizedString( @"IDS_INIT_ERROR_MESSAGE", nil );
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"error" message:IDS_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    //Model with CoreData
    application.applicationSupportsShakeToEdit = YES;
    self.model = [JMFCoreDataStack coreDataStackWithModelName:@"JMFCameraIOS"];
    JMFCameraIOS_MainViewController* mainVC = [[JMFCameraIOS_MainViewController alloc]initWithModel:self.model];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mainVC];
//  [self performCoreDataAutoSave];
    
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
- (void)applicationWillResignActive:(UIApplication*)application
{
    [self.model saveWithErrorBlock:^( NSError* error )
    {
        if( APPDEBUG ) NSLog( @"Error saving data in applicationWillResignActive: %@", error );
    }];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDidEnterBackground:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationDidEnterBackground:(UIApplication*)application
{
    [self.model saveWithErrorBlock:^( NSError* error )
    {
         if( APPDEBUG ) NSLog( @"Error saving data in applicationDidEnterBackground: %@", error );
    }];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationWillEnterForeground:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationWillEnterForeground:(UIApplication*)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDidBecomeActive:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationDidBecomeActive:(UIApplication*)application
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationWillTerminate:                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)applicationWillTerminate:(UIApplication*)application
{
    if( APPDEBUG ) NSLog(@"on applicationWillTerminate! here you can not save data." );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  application:handleEventsForBackgroundURLSession:completionHandler:     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString*)identifier completionHandler:( void (^)() )completionHandler
{
    if( APPDEBUG ) NSLog( @"on application:handleEventsForBackgroundURLSession:completionHandler: here you could save data but you problably did it before" );
}

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  performCoreDataAutoSave                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)performCoreDataAutoSave
{
    if( COREDATA_AUTOSAVE == YES )
    {
        if( APPDEBUG ) NSLog( @"in autosave..." );
        [self.model saveWithErrorBlock:^( NSError* error )
        {
             if( APPDEBUG ) NSLog( @"Error saving data in performCoredataAutosave %@", error);
        }];
        [self performSelector:@selector( performCoreDataAutoSave ) withObject:nil afterDelay: COREDATA_AUTOSAVE_DELAY];
    }
}

@end
