/***************************************************************************/
/*                                                                         */
/*  JMFFlickrUpload.h                                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Upload Photo Class definition file                 */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>
#import "JMFFlickr.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class forwarding                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class JMFFlickrUpload;
@class JMFFlickrUploadResponse;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUploadDelegate protocol definition                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@protocol JMFFlickrUploadDelegate < NSObject >
@optional

- (void)flickrDidFinishUpload:(JMFFlickrUpload*)flickrUpload response:(JMFFlickrUploadResponse*)response error:(NSError*)error;
- (void)flickrUpload:(JMFFlickrUpload*)flickrUpload progress:(float)percentage;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUpload Class Definition                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrUpload : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) NSString*                      imageFilePath;
@property (nonatomic,strong) NSString*                      token;
@property (nonatomic,strong) NSString*                      tokenSecret;
@property (nonatomic,strong) id< JMFFlickrUploadDelegate >  delegate;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithToken:(NSString*)token tokenSecret:(NSString*)tokenSecret delegate:(id< JMFFlickrUploadDelegate >)delegate;
- (void)uploadImage:(UIImage*)image title:(NSString*)title description:(NSString*)description fileName:(NSString*)fileName;
@end
