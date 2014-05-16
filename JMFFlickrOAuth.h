/***************************************************************************/
/*                                                                         */
/*  JMFFlickrOAuth.h                                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr OAuth Authentication Class definition file         */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         View: http://www.flickr.com/services/api/auth.oauth.html        */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class forwarding                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@class JMFFlickrOAuth;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrOAuthDelegate protocol definition                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@protocol JMFFlickrOAuthDelegate < NSObject >
@required

- (void)flickrDidAuthorize:(JMFFlickrOAuth*)flickr;
- (void)flickrDidNotAuthorize:(JMFFlickrOAuth*)flickr error:(NSError*)error;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrOAuth Class interface definition                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrOAuth : NSObject < UIWebViewDelegate, NSURLConnectionDelegate >

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) UIWebView*                     webView;
@property (nonatomic,strong) UIActivityIndicatorView*       activityIndicator;
@property (nonatomic,strong) NSString*                      token;
@property (nonatomic,strong) NSString*                      tokenSecret;
@property (nonatomic,strong) id< JMFFlickrOAuthDelegate >   delegate;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithWebView:(UIWebView*)webView delegate:(id<JMFFlickrOAuthDelegate>)delegate;
- (void)authenticate;

@end
