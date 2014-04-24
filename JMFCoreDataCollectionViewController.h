/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataCollectionViewController.h                                  */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData CollectionView Controller Class definition file  */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Adapted from JMFCoreDataTableViewController               */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataCollectionViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (strong, nonatomic) NSFetchedResultsController*   fetchedResultsController;
@property (nonatomic)         BOOL                          bSuspendAutomaticTrackingOfChangesInManagedObjectContext;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController collectionViewLayout:(UICollectionViewLayout*)layout;
- (void)setFetchedResultsController:(NSFetchedResultsController*)newFetchedResultsController;
- (void)performFetch;
- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)bSuspend;
- (void)endSuspensionOfUpdatesDueToContextChanges;

@end