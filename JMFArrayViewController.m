/***************************************************************************/
/*                                                                         */
/*  JMFArrayViewController.m                                               */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Array View Controller Class implementation file           */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: TableViewController + CollectionViewController            */
/*                                                                         */
/*  Docs: http://www.stanford.edu/class/cs193p/cgi-bin/drupal/node/389     */
/*                                                                         */
/***************************************************************************/
#import "JMFArrayViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFArrayViewController Class Interface                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFArrayViewController()
{
    BOOL    m_bBeganUpdates;
}
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFArrayViewController Class implementation                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFArrayViewController

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
/*  initWithModel:frame:style:collectionViewLayout:viewMode:               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(NSMutableArray*)model frame:(CGRect)frame style:(UITableViewStyle)style collectioViewLayout:(UICollectionViewLayout*)layout viewMode:(JMFArrayViewMode)viewMode
{
    if( self = [super init] )
    {
        self.model          = model;
        self.tableView      = [[UITableView alloc] initWithFrame:frame style:style];
        self.layout         = layout;
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.viewMode       = viewMode;
        
        self.tableView.dataSource       = self;
        self.tableView.delegate         = self;
        self.collectionView.dataSource  = self;
        self.collectionView.delegate    = self;
        
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.collectionView];
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
    return ( self.viewMode == JMFArrayViewModeList ) ? 1 : 0;
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
    return ( self.viewMode == JMFArrayViewModeList ) ? self.model.count : 0;
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
    return ( self.viewMode == JMFArrayViewModeMosaic ) ? 1 : 0;
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
    return ( self.viewMode == JMFArrayViewModeMosaic ) ? self.model.count : 0;
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
- (void)setViewMode:(JMFArrayViewMode)newViewMode
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
    self.tableView.hidden       = ( self.viewMode != JMFArrayViewModeList );
    self.collectionView.hidden  = ( self.viewMode != JMFArrayViewModeMosaic );
}

@end

