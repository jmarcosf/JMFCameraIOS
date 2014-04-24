/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataTableViewController.h                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData TableView Controller Class definition file       */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: See AGTCoreDataTableViewController                        */
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
/*  JMFCoreDataTableViewController Class Interface                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

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
/*  Initialization & Instance Methods                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController style:(UITableViewStyle)style;
- (void)setFetchedResultsController:(NSFetchedResultsController*)newFetchedResultsController;
- (void)performFetch;
- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)bSuspend;
- (void)endSuspensionOfUpdatesDueToContextChanges;

@end