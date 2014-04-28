/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_AlbumViewController.h                                     */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Album View Controller Class definition file               */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <UIKit/UIKit.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_AlbumViewController Class Interface                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_AlbumViewController : UIViewController <UIScrollViewDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Properties                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) NSFetchedResultsController*    fetchedResultsController;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBOutlets                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (weak, nonatomic) IBOutlet UIScrollView*      iboScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl*     iboPageControl;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* Instance Methods                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* IBActions                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onPageSelected:(id)sender;

@end
