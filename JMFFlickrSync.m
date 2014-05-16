/***************************************************************************/
/*                                                                         */
/*  JMFFlickrSync.m                                                        */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Sync Class implementation file                     */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <CommonCrypto/CommonHMAC.h>
#import "JMFFlickrSync.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrSync Interface Definition                                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrSync ()
{
    NSTimeInterval      appInterval;
    JMFFlickrUpload*    uploadTask;
    JMFPhoto*           currentPhoto;
    BOOL                bStopped;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrSync Class Implementation                                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFlickrSync

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithFetchedResultsController:delegate:                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController delegate:(id< JMFFlickrSyncDelegate >)delegate
{
    if( self = [super init] )
    {
        self.fetchedResultsController = fetchedResultsController;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - JMFFlickrUploadDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUploadDelegate Methods                                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrUpload:progress:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)flickrUpload:(JMFFlickrUpload*)flickrUpload progress:(float)percentage
{
    NSIndexPath* indexPath = [self.fetchedResultsController indexPathForObject:currentPhoto];
    if( [self.delegate respondsToSelector:@selector( uploadProgressForPhoto:atIndexPath:progress: )] )
    {
        dispatch_async( dispatch_get_main_queue(), ^
        {
            [self.delegate uploadProgressForPhoto:currentPhoto atIndexPath:indexPath progress:percentage];
        });
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrDidFinishUpload:response:error:                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)flickrDidFinishUpload:(JMFFlickrUpload*)flickrUpload response:(JMFFlickrUploadResponse*)response error:(NSError*)error
{
    if( error == nil && response.error == nil )
    {
        NSIndexPath* indexPath = [self.fetchedResultsController indexPathForObject:currentPhoto];
        currentPhoto.flickrPhotoId = response.photoId;
        currentPhoto.uploaded = [NSNumber numberWithBool:YES];
        currentPhoto.uploadedDate = [NSDate date];
        if( [self.delegate respondsToSelector:@selector( didFinishUploadPhoto:atIndexPath: )] )
        {
            dispatch_async( dispatch_get_main_queue(), ^
            {
                [self.delegate didFinishUploadPhoto:currentPhoto atIndexPath:indexPath];
            });
        }
    }
    
    dispatch_async( dispatch_get_main_queue(), ^
    {
        [self performSelector:@selector( upload ) withObject:nil afterDelay: appInterval];
    });
}

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  start                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)start
{
    bStopped = NO;

    NSUserDefaults* appPreferences = [NSUserDefaults standardUserDefaults];
    appInterval = [[appPreferences valueForKey:PREFERENCE_SYNC_INTERVAL_KEY]doubleValue];
    NSString* flickrToken = [appPreferences valueForKey:PREFERENCE_FLICKR_TOKEN_KEY];
    NSString* flickrTokenSecret = [appPreferences valueForKey:PREFERENCE_FLICKR_TOKEN_SECRET_KEY];
    
    if( flickrToken && flickrTokenSecret )
    {
        uploadTask = [[JMFFlickrUpload alloc]initWithToken:flickrToken tokenSecret:flickrTokenSecret delegate:self];
        [self performSelector:@selector( upload ) withObject:nil afterDelay: appInterval];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  stop                                                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)stop
{
    bStopped = YES;
    uploadTask = nil;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  upload                                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)upload
{
    currentPhoto = nil;
    if( !bStopped && uploadTask )
    {
        for( JMFPhoto* photo in [self.fetchedResultsController fetchedObjects] )
        {
            if( [photo.uploaded boolValue] == NO )
            {
                currentPhoto = photo;
                UIImage* image = [UIImage imageWithContentsOfFile:photo.sourceImageUrl];
                [uploadTask uploadImage:image
                                  title:photo.name
                            description:@"Image Uploaded from JMFCameraIOS"
                               fileName:photo.name];
                break;
            }
        }
    }
    
    if( !currentPhoto )
    {
        if( [self.delegate respondsToSelector:@selector( didFinishUpload )] )
        {
            dispatch_async( dispatch_get_main_queue(), ^
            {
                [self.delegate didFinishUpload];
            });
        }
    }
}

@end
