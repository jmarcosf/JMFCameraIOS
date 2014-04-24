/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataCollectionViewController.m                                  */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData CollectionView Controller Class implementation   */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Adapted from JMFCoreDataTableViewController               */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import "JMFCoreDataCollectionViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataCollectionViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataCollectionViewController()


@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataCollectionViewController Class implementation               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCoreDataCollectionViewController

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIViewController Override Methods                                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  shouldAutorotateToInterfaceOrientation:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Initialization Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithFetchedResultsController:layout:                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController collectionViewLayout:(UICollectionViewLayout*)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        self.fetchedResultsController = fetchedResultsController;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UICollectionViewDataSource Methods                                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfSectionsInCollectionView:                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:numberOfItemsInSection:                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

#pragma mark - NSFetchedResultsControllerDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSFetchedResultsControllerDelegate Methods                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controllerWillChangeContent:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    if( !self.bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
    {
        //TODO:
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controller:didChangeSection:atIndex:forChangeType:                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex orChangeType:(NSFetchedResultsChangeType)type
{
    if( !self.bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
    {
        switch( type )
        {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
        }
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    if( !self.bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
    {
        switch( type )
        {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                break;
        }
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  controllerDidChangeContent:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    //TODO:
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
/*  setFetchedResultsController:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setFetchedResultsController:(NSFetchedResultsController*)newFetchedResultsController
{
    NSFetchedResultsController* oldFetchedResultsController = _fetchedResultsController;
    if( newFetchedResultsController != oldFetchedResultsController )
    {
        _fetchedResultsController = newFetchedResultsController;
        newFetchedResultsController.delegate = self;
        
        if( ( !self.title || [self.title isEqualToString:oldFetchedResultsController.fetchRequest.entity.name] ) &&
           ( !self.navigationController || !self.navigationItem.title ) )
        {
            self.title = newFetchedResultsController.fetchRequest.entity.name;
        }
        
        if( newFetchedResultsController )
        {
            if( DEBUG ) NSLog( @"[%@ %@] %@",
                              NSStringFromClass( [self class] ),
                              NSStringFromSelector( _cmd ),
                              oldFetchedResultsController ? @"updated" : @"set" );
            [self performFetch];
        }
        else
        {
            if( DEBUG ) NSLog( @"[%@ %@] reset to nil",
                              NSStringFromClass( [self class] ),
                              NSStringFromSelector( _cmd ) );
            [self.collectionView reloadData];
        }
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  performFetch                                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)performFetch
{
    if( self.fetchedResultsController )
    {
        if( self.fetchedResultsController.fetchRequest.predicate )
        {
            if( DEBUG ) NSLog( @"[%@ %@] fetching %@ with predicate: %@",
                              NSStringFromClass( [self class] ),
                              NSStringFromSelector( _cmd ),
                              self.fetchedResultsController.fetchRequest.entityName,
                              self.fetchedResultsController.fetchRequest.predicate );
        }
        else
        {
            if( DEBUG ) NSLog( @"[%@ %@] fetching all %@ (i.e., no predicate)",
                              NSStringFromClass( [self class] ),
                              NSStringFromSelector( _cmd ),
                              self.fetchedResultsController.fetchRequest.entityName );
        }
        
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if( error && DEBUG ) NSLog( @"[%@ %@] %@ (%@)",
                                   NSStringFromClass( [self class] ),
                                   NSStringFromSelector( _cmd ),
                                   [error localizedDescription],
                                   [error localizedFailureReason] );
    }
    else
    {
        if( DEBUG ) NSLog( @"[%@ %@] no NSFetchedResultsController (yet?)",
                          NSStringFromClass( [self class] ),
                          NSStringFromSelector( _cmd ) );
    }
    [self.collectionView reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setSuspendAutomaticTrackingOfChangesInManagedObjectContext:            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)bSuspend
{
    if( bSuspend )
    {
        _bSuspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    }
    else
    {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  endSuspensionOfUpdatesDueToContextChanges                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _bSuspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

@end
