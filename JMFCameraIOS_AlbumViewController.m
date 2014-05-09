/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_AlbumViewController.m                                     */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Album View Controller Class implementation file           */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_AlbumViewController.h"
#import "JMFPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Macros                                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define SCROLL_SIZE                                 self.iboScrollView.frame.size

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_AlbumViewController Class Interface                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_AlbumViewController ()
{
    long     albumCount;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_AlbumViewController Class Implemantation                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_AlbumViewController

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
/*  initWithAlbum:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.fetchedResultsController = fetchedResultsController;
        albumCount = [fetchedResultsController fetchedObjects].count;
    }
    return self;
}

#pragma mark - UIViewController Override Methods
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
/*  viewDidLoad                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = ResString( @"IDS_ALBUM" );
    
    self.iboScrollView.delegate = self;
    self.iboPageControl.numberOfPages = albumCount;
    self.iboPageControl.backgroundColor = Rgb2UIColor( 245, 200, 35 );
    
    for( int i = 0; i < albumCount; i++ )
    {
        JMFPhoto* photo = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:photo.sourceImageUrl]];
        imageView.frame = CGRectMake(i * SCROLL_SIZE.width, 0, SCROLL_SIZE.width, SCROLL_SIZE.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];
        [self.iboScrollView addSubview:imageView];
    }
    
    self.iboScrollView.contentSize = CGSizeMake( SCROLL_SIZE.width * albumCount, SCROLL_SIZE.width);
    self.iboScrollView.pagingEnabled = YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewVillAppear:                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  didReceiveMemoryWarning                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIScrollViewDelegate Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  scrollViewDidEndDecelerating:                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    int currentPage = offset / scrollView.frame.size.width;
    self.iboPageControl.currentPage = currentPage;
}

#pragma mark - IBAction Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  IBAction Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onPageSelected:                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onPageSelected:(id)sender
{
    CGRect rect = CGRectMake( self.iboPageControl.currentPage * SCROLL_SIZE.width, 0, SCROLL_SIZE.width, SCROLL_SIZE.height );
    [self.iboScrollView scrollRectToVisible:rect animated:YES];
}

@end