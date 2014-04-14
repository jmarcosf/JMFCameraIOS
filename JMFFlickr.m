/***************************************************************************/
/*                                                                         */
/*  JMFFlickr.m                                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Search Class implementation file                   */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Modified from Brandon Trebitowski file                    */
/*                                                                         */
/***************************************************************************/
#import "JMFFlickr.h"
#import "JMFFlickrPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define kFlickrAPIKey               @"f886542ef1da27324037337a59dee61a"
#define IDS_FLICKR_SEARCH_URL       @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=10&format=json&nojsoncallback=1"
#define IDS_FLICKR_PHOTO_URL        @"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickr Class implementation                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFlickr

#pragma mark - Class Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Methods                                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrSearchUrlForSearchTerm:                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)flickrSearchUrlForSearchTerm:(NSString*)searchTerm
{
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:IDS_FLICKR_SEARCH_URL, kFlickrAPIKey, searchTerm];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrPhotoUrlForFlickrPhoto:size:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)flickrPhotoUrlForFlickrPhoto:(JMFFlickrPhoto*)flickrPhoto size:(NSString*)size
{
    if( !size ) size = @"m";
    
    return [NSString stringWithFormat:IDS_FLICKR_PHOTO_URL, flickrPhoto.farm, flickrPhoto.server, flickrPhoto.photoID,flickrPhoto.secret, size];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  loadImageForPhoto:thumbnail:completionBlock:                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (void)loadImageForPhoto:(JMFFlickrPhoto*)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
    NSString*           size = thumbnail ? @"m" : @"b";
    NSString*           searchUrl = [JMFFlickr flickrPhotoUrlForFlickrPhoto:flickrPhoto size:size];
    dispatch_queue_t    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async( queue, ^
    {
        NSError* error = nil;
        NSData*  imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchUrl] options:0 error:&error];
        if( !error )
        {
            UIImage* image = [UIImage imageWithData:imageData];

            if( [size isEqualToString:@"m"] ) flickrPhoto.thumbnail = image;
            else flickrPhoto.largeImage = image;
            
            if( completionBlock != nil ) completionBlock( image, nil );
        }
        else if( completionBlock != nil ) completionBlock( nil, error );
    } );
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
/*  searchFlickrForTerm:completionBlock:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)searchFlickrForTerm:(NSString*)term completionBlock:(FlickrSearchCompletionBlock)completionBlock
{
    NSString*           searchUrl = [JMFFlickr flickrSearchUrlForSearchTerm:term];
    dispatch_queue_t    queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
    
    dispatch_async( queue, ^
    {
        NSError*    error = nil;
        NSString*   searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchUrl] encoding:NSUTF8StringEncoding error:&error];
        if( !error )
        {
            // Parse the JSON Response
            NSData*         jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary*   searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            if( !error )
            {
                NSString* status = searchResultsDict[ @"stat" ];
                if( ![status isEqualToString:@"fail"] )
                {
                    NSArray*        objPhotos = searchResultsDict[@"photos"][@"photo"];
                    NSMutableArray* flickrPhotos = [@[] mutableCopy];
                    
                    for( NSMutableDictionary* objPhoto in objPhotos )
                    {
                        JMFFlickrPhoto* photo = [[JMFFlickrPhoto alloc] init];
                        photo.farm = [objPhoto[@"farm"] intValue];
                        photo.server = [objPhoto[@"server"] intValue];
                        photo.secret = objPhoto[@"secret"];
                        photo.photoID = [objPhoto[@"id"] longLongValue];
                        
                        NSString*   photoUrl = [JMFFlickr flickrPhotoUrlForFlickrPhoto:photo size:@"m"];
                        NSData*     imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl] options:0 error:&error];
                        UIImage*    image = [UIImage imageWithData:imageData];

                        photo.thumbnail = image;
                        [flickrPhotos addObject:photo];
                    }
                    
                    if( completionBlock != nil ) completionBlock( term, flickrPhotos, nil );
                }
                else if( completionBlock != nil )
                {
                    NSError* error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:searchResultsDict[@"message"]}];
                    completionBlock( term, nil, error );
                }
            }
            else if( completionBlock != nil ) completionBlock( term, nil, error );
        }
        else if( completionBlock != nil ) completionBlock( term, nil, error );
    });
}

@end
