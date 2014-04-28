/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataStack.h                                                     */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Core Data Stack Class implementation file                 */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Modified from AGTCoreDataStack.h                          */
/*                                                                         */
/***************************************************************************/
#import <CoreData/CoreData.h>
#import "JMFCoreDataStack.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataStack Class Interface                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataStack ()
@property (strong, nonatomic, readonly) NSManagedObjectModel*           model;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator*   storeCoordinator;
@property (strong, nonatomic) NSURL*                                    modelUrl;
@property (strong, nonatomic) NSURL*                                    databaseUrl;
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataStack Class implementation                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCoreDataStack

#pragma mark -  Properties
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Synthesize Properties                                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@synthesize model               = _model;                   //When using readonly property with custom getter,
@synthesize storeCoordinator    = _storeCoordinator;        //     auto-synthesize is disabled
@synthesize context             = _context;                 //See: http://www.cocoaosx.com/2012/12/04/auto-synthesize-property-reglas-excepciones/

/***************************************************************************/
/*                                                                         */
/*  model                                                                  */
/*                                                                         */
/***************************************************************************/
- (NSManagedObjectModel*)model
{
    if( _model == nil ) _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelUrl];
    return _model;
}

/***************************************************************************/
/*                                                                         */
/*  storeCoordinator                                                       */
/*                                                                         */
/***************************************************************************/
- (NSPersistentStoreCoordinator*)storeCoordinator
{
    if( _storeCoordinator == nil )
    {
        NSError* error = nil;
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        if( ![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:self.databaseUrl
                                                   options:nil
                                                     error:&error ] )
        {
            // Something went really wrong. Send a notification and return nil.
            NSNotification *note = [NSNotification
                                    notificationWithName:[JMFCoreDataStack persistentStoreCoordinatorErrorNotificationName]
                                    object:self
                                    userInfo:@{ @"Error" : error } ];
            [[NSNotificationCenter defaultCenter] postNotification:note];
            if( APPDEBUG ) NSLog( @"Error while adding a Store: %@", error );
            return nil;
        }
    }
    return _storeCoordinator;
}

/***************************************************************************/
/*                                                                         */
/*  context                                                                */
/*                                                                         */
/***************************************************************************/
- (NSManagedObjectContext*)context
{
    if( _context == nil )
    {
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = self.storeCoordinator;
    }
    return _context;
}

#pragma mark - Class Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Methods                                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  persistentStoreCoordinatorErrorNotificationName                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)persistentStoreCoordinatorErrorNotificationName
{
    return @"persistentStoreCoordinatorErrorNotificationName";
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDocumentsDirectory                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  coreDataStackWithModelName:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString*)modelName
{
    return [self coreDataStackWithModelName:modelName databaseFileName:nil];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  coreDataStackWithModelName:databaseFilename:                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString *)modelName databaseFileName:(NSString*)databaseFileName
{
    NSURL* url = ( databaseFileName != nil ) ? [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databaseFileName]
                                             : [[self applicationDocumentsDirectory] URLByAppendingPathComponent:modelName];

    return [self coreDataStackWithModelName:modelName databaseUrl:url];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  coreDataStackWithModelName:databaseUrl:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (JMFCoreDataStack*)coreDataStackWithModelName:(NSString*)modelName databaseUrl:(NSURL*)databaseUrl
{
    return [[self alloc] initWithModelName:modelName databaseUrl:databaseUrl];
}

#pragma mark - Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithModelName:databaseUrl:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModelName:(NSString*)modelName databaseUrl:(NSURL*)databaseUrl
{
    if( self = [super init] )
    {
        self.modelUrl = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        self.databaseUrl = databaseUrl;
    }
    
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  dropDatabaseData:                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)dropDatabaseData
{
    NSError* error = nil;
    for( NSPersistentStore* store in self.storeCoordinator.persistentStores )
    {
        if( ![self.storeCoordinator removePersistentStore:store error:&error] )
        {
            if( APPDEBUG ) NSLog(@"Error while removing store %@ from store coordinator %@", store, self.storeCoordinator);
        }
    }
    if( ![[NSFileManager defaultManager] removeItemAtURL:self.databaseUrl error:&error] )
    {
        if( APPDEBUG ) NSLog( @"Error removing %@: %@", self.databaseUrl, error );
    }
    
    // The Core Data stack does not like you removing the file under it. If you want to delete the file
    // you should tear down the stack, delete the file and then reconstruct the stack.
    // Part of the problem is that the stack keeps a cache of the data that is in the file. When you
    // remove the file you don't have a way to clear that cache and you are then putting
    // Core Data into an unknown and unstable state.
    _context = nil;
    _storeCoordinator = nil;
    [self context]; // this will rebuild the stack
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  saveWithErrorBlock:                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)saveWithErrorBlock:(void(^)(NSError* error))errorBlock
{
    // If a context is nil, saving it should also be considered an error, as being nil
    // might be the result of a previous errot while creating the database.
    NSError* error = nil;
    if( !_context )
    {
        NSString* errorKey = @"Attempted to save a nil NSManagedObjectContext. This JMFCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file.";
        error = [NSError errorWithDomain:@"JMFCoreDataStack"
                                  code:1
                              userInfo:@{ NSLocalizedDescriptionKey:errorKey }];
        if( errorBlock != nil ) errorBlock( error );
    }
    else if( self.context.hasChanges )
    {
        if( ![self.context save:&error] )
        {
            if( errorBlock != nil ) errorBlock( error );
        }
    }
}












@end
