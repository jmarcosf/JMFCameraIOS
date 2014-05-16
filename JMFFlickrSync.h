/***************************************************************************/
/*                                                                         */
/*  JMFFlickrSync.h                                                        */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Sync Class definition file                         */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import "JMFFlickr.h"
#import "JMFPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class forwarding                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class JMFFlickrSync;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrSyncDelegate protocol definition                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@protocol JMFFlickrSyncDelegate < NSObject >
@optional

- (void)uploadProgressForPhoto:(JMFPhoto*)photo atIndexPath:(NSIndexPath*)indexPath progress:(float)percentage;
- (void)didFinishUploadPhoto:(JMFPhoto*)photo atIndexPath:(NSIndexPath*)indexPath;
- (void)didFinishUpload;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrSync Class Interface                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrSync : NSObject <JMFFlickrUploadDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) NSFetchedResultsController*    fetchedResultsController;
@property (nonatomic,strong) id< JMFFlickrSyncDelegate >    delegate;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController delegate:(id< JMFFlickrSyncDelegate >)delegate;
- (void)start;
- (void)stop;
- (void)upload;

@end

