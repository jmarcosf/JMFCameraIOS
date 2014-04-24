/***************************************************************************/
/*                                                                         */
/*  JMFCoreDataViewController.h                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData View Controller Class definition file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: TableViewController + CollectionViewController            */
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
/*  Enums                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
typedef NS_ENUM( NSInteger, JMFCoreDataViewMode )
{
    JMFCoreDataViewModeNone =  0,
    JMFCoreDataViewMosaic   =  1,
    JMFCoreDataViewList     =  2,
    JMFCoreDataViewUnknown  = -1,
};

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCoreDataViewController Class Interface                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCoreDataViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                                                         UITableViewDataSource, UITableViewDelegate,
                                                         NSFetchedResultsControllerDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic, strong) NSFetchedResultsController*   fetchedResultsController;
@property (nonatomic, retain) UITableView*                  tableView;
@property (nonatomic, retain) UICollectionView*             collectionView;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization & Instance Methods                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                  frame:(CGRect)frame
                                 style:(UITableViewStyle)style
                   collectioViewLayout:(UICollectionViewLayout*)layout
                              viewMode:(JMFCoreDataViewMode)viewMode;
- (void)setFetchedResultsController:(NSFetchedResultsController*)newFetchedResultsController;
- (void)performFetch;
- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)bSuspend;
- (void)endSuspensionOfUpdatesDueToContextChanges;
- (void)setFrame:(CGRect)newFrame;
- (void)setViewMode:(JMFCoreDataViewMode)newViewMode;
- (void)reloadData;

@end