/***************************************************************************/
/*                                                                         */
/*  JMFFlickr.h                                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Search Class definition file                       */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Modified from Brandon Trebitowski file                    */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import "JMFFlickrPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Typedefs                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
typedef void (^FlickrPhotoCompletionBlock)(UIImage* photoImage, NSError* error);
typedef void (^FlickrSearchCompletionBlock)(NSString* searchTerm, NSArray* results, NSError* error);

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickr Class Interface                                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickr : NSObject

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property(strong) NSString*     apiKey;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class Methods                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)flickrSearchUrlForSearchTerm:(NSString*)searchTerm;
+ (NSString*)flickrPhotoUrlForFlickrPhoto:(JMFFlickrPhoto*)flickrPhoto size:(NSString*)size;
+ (void)loadImageForPhoto:(JMFFlickrPhoto*)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock)completionBlock;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)searchFlickrForTerm:(NSString*)term largeImage:(BOOL)bLargeImage completionBlock:(FlickrSearchCompletionBlock)completionBlock;

@end
