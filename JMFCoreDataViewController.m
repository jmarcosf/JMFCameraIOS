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
    BOOL    m_bSuspendAutomaticTrackingOfChangesInManagedObjectContext;
    BOOL    m_bBeganUpdates;
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
/*  initWithFetchedResultsController:frame:style:                          */
/*         collectionViewLayout:viewMode:                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                 frame:(CGRect)frame
                                 style:(UITableViewStyle)style
                  collectionViewLayout:(UICollectionViewLayout*)layout
                              viewMode:(JMFCoreDataViewMode)viewMode
{
    if( self = [super init] )
    {
        self.fetchedResultsController   = fetchedResultsController;
        self.tableView                  = [[UITableView alloc] initWithFrame:frame style:style];
        self.layout                     = layout;
        self.collectionView             = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _viewMode                       = viewMode;
        
        self.tableView.dataSource       = self;
        self.tableView.delegate         = self;
        self.collectionView.dataSource  = self;
        self.collectionView.delegate    = self;
        
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.collectionView];
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
    return ( self.viewMode == JMFCoreDataViewModeMosaic ) ? [[self.fetchedResultsController sections] count] : 0;
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
    return ( self.viewMode == JMFCoreDataViewModeMosaic ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] : 0;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  collectionView:cellForItemAtIndexPath:                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    //NOTE: this method must be implemented by derived classes
    [NSException raise:@"Invoked abstract method" format:@"Derived class must implement this method"];
    return nil;
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
    return ( self.viewMode == JMFCoreDataViewModeList ) ? [[self.fetchedResultsController sections] count] : 0;
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
    return ( self.viewMode == JMFCoreDataViewModeList ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects] : 0;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:cellForRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NOTE: this method must be implemented by derived classes
    [NSException raise:@"Invoked abstract method" format:@"Derived class must implement this method"];
    return nil;
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
	return ( self.viewMode == JMFCoreDataViewModeList ) ? [[[self.fetchedResultsController sections] objectAtIndex:section] name] : nil;
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
	return ( self.viewMode == JMFCoreDataViewModeList ) ? [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index] : 0;
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
    return ( self.viewMode == JMFCoreDataViewModeList ) ? [self.fetchedResultsController sectionIndexTitles] : nil;
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
    if( self.viewMode == JMFCoreDataViewModeList )
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
                if( self.viewMode == JMFCoreDataViewModeMosaic )    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                else if( self.viewMode == JMFCoreDataViewModeList ) [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                if( self.viewMode == JMFCoreDataViewModeMosaic )    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                else if( self.viewMode == JMFCoreDataViewModeList ) [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
                if( self.viewMode == JMFCoreDataViewModeMosaic )   [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                else if( self.viewMode == JMFCoreDataViewModeList) [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                if( self.viewMode == JMFCoreDataViewModeMosaic )    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                else if( self.viewMode == JMFCoreDataViewModeList ) [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                if( self.viewMode == JMFCoreDataViewModeMosaic )    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                else if( self.viewMode == JMFCoreDataViewModeList ) [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                if( self.viewMode == JMFCoreDataViewModeMosaic )
                {
                    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                }
                else if( self.viewMode == JMFCoreDataViewModeList )
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
    if( self.viewMode == JMFCoreDataViewModeList )
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
            if( APPDEBUG ) NSLog( @"[%@ %@] fetching all %@ (i.e., no predicate)",
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
    _viewMode = newViewMode;
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
    self.tableView.hidden       = ( self.viewMode != JMFCoreDataViewModeList );
    self.collectionView.hidden  = ( self.viewMode != JMFCoreDataViewModeMosaic );
}

@end

