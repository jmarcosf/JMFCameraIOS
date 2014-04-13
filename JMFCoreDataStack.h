/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataStack.h                                                     */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Core Data Stack Class definition file                     */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Modified from  AGTCoreDataStack.h                         */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class forwarding                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class NSManagedObjectContext;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataStack Class Interface                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataStack : NSObject

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (strong, nonatomic, readonly) NSManagedObjectContext* context;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class Methods                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)persistentStoreCoordinatorErrorNotificationName;
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString*)modelName;
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString*)modelName databaseFileName:(NSString*)databaseFileName;
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString*)modelName databaseUrl:(NSURL*)databseUrl;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModelName:(NSString*)modelName databaseUrl:(NSURL*)databaseUrl;
- (void)dropDatabaseData;
- (void)saveWithErrorBlock:(void(^)(NSError* error))errorBlock;

@end
