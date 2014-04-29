/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataTableViewController.m                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData TableView Controller Class implementation file   */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: See AGTCoreDataTableViewController                        */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import "JMFCoreDataTableViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataTableViewController Class Interface                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataTableViewController()

@property (nonatomic) BOOL bBeganUpdates;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataTableViewController Class implementation                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCoreDataTableViewController

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
/*  initWithFetchedResultsController:style:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController style:(UITableViewStyle)style
{
    if( self = [super initWithStyle:style] )
    {
        self.fetchedResultsController = fetchedResultsController;
    }
    return self;
}

#pragma mark - UITableViewDataSource
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewDataSource Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfSectionsInTableView:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[self.fetchedResultsController sections] count];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:numberOfRowsInSection:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:titleForHeaderInSection:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:sectionForSectionIndexTitle:atIndex:                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  sectionIndexTitlesForTableView:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
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
        [self.tableView beginUpdates];
        self.bBeganUpdates = YES;
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
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if( self.bBeganUpdates ) [self.tableView endUpdates];
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
            if( APPDEBUG ) NSLog( @"[%@ %@] %@",
                           NSStringFromClass( [self class] ),
                           NSStringFromSelector( _cmd ),
                           oldFetchedResultsController ? @"updated" : @"set" );
            [self performFetch];
        }
        else
        {
            if( APPDEBUG ) NSLog( @"[%@ %@] reset to nil",
                           NSStringFromClass( [self class] ),
                           NSStringFromSelector( _cmd ) );
            [self.tableView reloadData];
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
            if( APPDEBUG ) NSLog( @"[%@ %@] fetching %@ with predicate: %@",
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
        if( error && APPDEBUG ) NSLog( @"[%@ %@] %@ (%@)",
                                NSStringFromClass( [self class] ),
                                NSStringFromSelector( _cmd ),
                                [error localizedDescription],
                                [error localizedFailureReason] );
    }
    else
    {
        if( APPDEBUG ) NSLog( @"[%@ %@] no NSFetchedResultsController (yet?)",
                       NSStringFromClass( [self class] ),
                       NSStringFromSelector( _cmd ) );
    }
    [self.tableView reloadData];
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

