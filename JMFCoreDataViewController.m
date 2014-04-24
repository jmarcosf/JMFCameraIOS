/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataViewController.m                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData View Controller Class implementation file        */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: TableViewController + CollectionViewController            */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import "JMFCoreDataViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataViewController Class Interface                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataViewController()
{
    BOOL                    m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext;
    BOOL                    m_bBeganUpdates;
    JMFCoreDataViewMode     m_ViewMode;
}
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataViewController Class implementation                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCoreDataViewController

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
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                 frame:(CGRect)frame
                                 style:(UITableViewStyle)style
                   collectioViewLayout:(UICollectionViewLayout*)layout
                              viewMode:(JMFCoreDataViewMode)viewMode
{
    if( self = [super init] )
    {
        self.fetchedResultsController   = fetchedResultsController;
        self.tableView                  = [[UITableView alloc] initWithFrame:frame style:style];
        self.collectionView             = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        m_ViewMode                      = viewMode;
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
    return ( m_ViewMode == JMFCoreDataViewList ) ? [[self.fetchedResultsController sections] count] : 0;
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
    return ( m_ViewMode == JMFCoreDataViewList ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] : 0;
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
	return ( m_ViewMode == JMFCoreDataViewList ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] name] : nil;
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
	return ( m_ViewMode == JMFCoreDataViewList ) ? [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index] : 0;
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
    return ( m_ViewMode == JMFCoreDataViewList ) ? [self.fetchedResultsController sectionIndexTitles] : nil;
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
    return ( m_ViewMode == JMFCoreDataViewMosaic ) ? [[self.fetchedResultsController sections] count] : 0;
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
    return ( m_ViewMode == JMFCoreDataViewMosaic ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] : 0;
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
    if( m_ViewMode == JMFCoreDataViewList )
    {
        if( !m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
        {
            [self.tableView beginUpdates];
            m_bBeganUpdates = YES;
        }
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
    if( !m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
    {
        switch( type )
        {
            case NSFetchedResultsChangeInsert:
                if( m_ViewMode == JMFCoreDataViewMosaic )    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                else if( m_ViewMode == JMFCoreDataViewList ) [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                if( m_ViewMode == JMFCoreDataViewMosaic )    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                else if( m_ViewMode == JMFCoreDataViewList ) [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
    if( !m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext )
    {
        switch( type )
        {
            case NSFetchedResultsChangeInsert:
                if( m_ViewMode == JMFCoreDataViewMosaic )   [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                else if( m_ViewMode == JMFCoreDataViewList) [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                if( m_ViewMode == JMFCoreDataViewMosaic )    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                else if( m_ViewMode == JMFCoreDataViewList ) [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                if( m_ViewMode == JMFCoreDataViewMosaic )    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                else if( m_ViewMode == JMFCoreDataViewList ) [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                if( m_ViewMode == JMFCoreDataViewMosaic )
                {
                    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                }
                else if( m_ViewMode == JMFCoreDataViewList )
                {
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
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
    if( m_ViewMode == JMFCoreDataViewList )
    {
        if( m_bBeganUpdates ) [self.tableView endUpdates];
    }
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
    [self reloadData];
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
        m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
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
    m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setFrame:                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setFrame:(CGRect)newFrame
{
    self.tableView.frame = self.collectionView.frame = newFrame;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setViewMode:                                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setViewMode:(JMFCoreDataViewMode)newViewMode
{
    m_ViewMode = newViewMode;
    [self reloadData];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setViewMode:                                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)reloadData
{
    //refresh both controls data to free memory
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - Instance Private Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Instance Private Methods                                               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  refreshControls                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)refreshControls
{
    self.tableView.hidden       = ( m_ViewMode != JMFCoreDataViewList );
    self.collectionView.hidden  = ( m_ViewMode != JMFCoreDataViewMosaic );
}

@end

