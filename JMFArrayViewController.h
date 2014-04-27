/***************************************************************************/
/*                                                                         */
/*  JMFArrayViewController.h                                               */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Array View Controller Class definition file               */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: TableViewController + CollectionViewController            */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Enums                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
typedef NS_ENUM( NSInteger, JMFArrayViewMode )
{
    JMFArrayViewModeNone     =  0,
    JMFArrayViewModeMosaic   =  1,
    JMFArrayViewModeList     =  2,
    JMFArrayViewModeUnknown  = -1,
};

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFArrayViewController Class Interface                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFArrayViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                                                      UITableViewDataSource, UITableViewDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic, strong) NSMutableArray*           model;
@property (nonatomic, retain) UITableView*              tableView;
@property (nonatomic, retain) UICollectionView*         collectionView;
@property (nonatomic, retain) UICollectionViewLayout*   layout;
@property (nonatomic)         JMFArrayViewMode          viewMode;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization & Instance Methods                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(NSMutableArray*)model frame:(CGRect)frame style:(UITableViewStyle)style collectionViewLayout:(UICollectionViewLayout*)layout viewMode:(JMFArrayViewMode)viewMode;
- (void)setFrame:(CGRect)newFrame;
- (void)setViewMode:(JMFArrayViewMode)newViewMode;
- (void)reloadData;

@end