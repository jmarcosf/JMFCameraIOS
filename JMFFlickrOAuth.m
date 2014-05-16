/***************************************************************************/
/*                                                                         */
/*  JMFFlickrOAuth.m                                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr OAuth Authentication Class implementation file     */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         View: http://www.flickr.com/services/api/auth.oauth.html        */
/*                                                                         */
/***************************************************************************/
#import <CommonCrypto/CommonHMAC.h>
#import "JMFFlickr.h"
#import "NSString+URLEncode.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Constants                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static NSString* kCallbackURL          = @"jmfcameraios://userauthorization";
static NSString* kRequestTokenBaseURL  = @"https://www.flickr.com/services/oauth/request_token";
static NSString* kAuthorizeBaseURL     = @"https://www.flickr.com/services/oauth/authorize";
static NSString* kAccessTokenBaseURL   = @"https://www.flickr.com/services/oauth/access_token";

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Enums                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
typedef enum
{
    FlickrOAuthStateRequestToken,
    FlickrOAuthStateAccessToken
} FlickrOAuthState;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrOAuth Interface implementation                                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFlickrOAuth
{
    FlickrOAuthState    currentState;
    NSMutableData*      receivedData;
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
/*  initWithWebView:delegate:                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithWebView:(UIWebView*)webView delegate:(id<JMFFlickrOAuthDelegate>)delegate
{
    if( self = [super init] )
    {
        self.delegate                = delegate;
        self.webView                 = webView;
        self.webView.delegate        = self;
        self.webView.scalesPageToFit = YES;
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  authenticate:                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)authenticate
{
    currentState = FlickrOAuthStateRequestToken;
    
    NSString* nonce = [JMFUtility generateUuidString];
    NSString* timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:nonce              forKey:@"oauth_nonce"];
    [parameters setValue:timestamp          forKey:@"oauth_timestamp"];
    [parameters setValue:kFlickrConsumerKey forKey:@"oauth_consumer_key"];
    [parameters setValue:kSignatureMethod   forKey:@"oauth_signature_method"];
    [parameters setValue:kOAuthVersion      forKey:@"oauth_version"];
    [parameters setValue:kCallbackURL       forKey:@"oauth_callback"];
    
    NSString* urlStringBeforeSignature = [self sortedURLStringFromDictionary:parameters urlEscape:YES];
    NSString* signature = [NSString stringWithFormat:@"GET&%@", urlStringBeforeSignature];
    NSString* signatureString = [self flickrOAuthSignatureFor:signature withKey:[kFlickrConsumerSecret stringByAppendingString:@"&"]];
    [parameters setValue:signatureString forKey:@"oauth_signature"];
    NSString* urlStringWithSignature = [self sortedURLStringFromDictionary:parameters urlEscape:NO];
    
    receivedData = [NSMutableData data];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStringWithSignature]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

#pragma mark - UIWebViewDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIWebViewDelegate Methods                                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  webView:shouldStartLoadWithRequest:navigationType:                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request URL];
    NSURL* callbackURL = [NSURL URLWithString:kCallbackURL];
    if( [[url host]isEqualToString:[callbackURL host]] )
    {
        [self handleCallBackURL:url];
        return NO;
    }
    return YES;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  webViewDidFinishLoad:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    if( self.activityIndicator )
    {
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
}

#pragma mark - NSURLConnectionDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSURLConnectionDelegate Methods                                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  connection:didReceiveResponse:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [receivedData setLength:0];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  connection:didReceiveData:                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receivedData appendData:data];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  connectionDidFinishLoading:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSMutableDictionary* paramsDictionary = [NSMutableDictionary dictionary];

    if( currentState == FlickrOAuthStateRequestToken )
    {
        NSString* response = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSArray* parameters = [response componentsSeparatedByString:@"&"];

        [parameters enumerateObjectsUsingBlock:^( NSString* element, NSUInteger idx, BOOL* stop )
        {
            NSArray* array = [element componentsSeparatedByString:@"="];
            NSString* key = [array objectAtIndex:0];
            NSString* value = [array objectAtIndex:1];
            [paramsDictionary setValue:value forKey:key];
        }];

        if( [[paramsDictionary objectForKey:@"oauth_callback_confirmed"] boolValue] == YES )
        {
            self.token = [paramsDictionary objectForKey:@"oauth_token"];
            self.tokenSecret = [paramsDictionary objectForKey:@"oauth_token_secret"];
            NSString* urlString = [NSString stringWithFormat:@"%@?oauth_token=%@&perms=%@", kAuthorizeBaseURL, self.token, @"delete"];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        }
        else
        {
            if( [ self.delegate respondsToSelector:@selector( flickrDidNotAuthorize:error: )] )
            {
                [self.delegate flickrDidNotAuthorize:self error:nil] ;
            }
        }
    }
    else if( currentState == FlickrOAuthStateAccessToken )
    {
        NSString* response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSArray* parameters = [response componentsSeparatedByString:@"&"];

        [parameters enumerateObjectsUsingBlock:^( NSString* element, NSUInteger idx, BOOL* stop )
        {
            NSArray* array = [element componentsSeparatedByString:@"="];
            NSString* key = [array objectAtIndex:0];
            NSString* value = [array objectAtIndex:1];
            [paramsDictionary setValue:value forKey:key];
        }];
        
        if( [[paramsDictionary objectForKey:@"username"]length] > 0 )
        {
            self.token = [paramsDictionary objectForKey:@"oauth_token"];
            self.tokenSecret = [paramsDictionary objectForKey:@"oauth_token_secret"];
            if( [self.delegate respondsToSelector:@selector( flickrDidAuthorize: )] )
            {
                [self.delegate flickrDidAuthorize:self];
            }
        } else
        {
            if( [self.delegate respondsToSelector:@selector( flickrDidNotAuthorize:error: )] )
            {
                [self.delegate flickrDidNotAuthorize:self error:nil];
            }
        }
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  connection:didFailWithError:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog( @"Connection failed with error: %@", error );
    
    if( [ self.delegate respondsToSelector:@selector( flickrDidNotAuthorize:error: )] )
    {
        [self.delegate flickrDidNotAuthorize:self error:error];
    }
}

#pragma mark - Utility Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Utility Methods                                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  extractVerifierFromURL:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)extractVerifierFromURL:(NSURL*)url
{
    NSArray*  parameters = [[url absoluteString]componentsSeparatedByString:@"&"];
    NSArray*  keyValue   = [[parameters objectAtIndex:1] componentsSeparatedByString:@"="];
    NSString* verifier   = [keyValue objectAtIndex:1];
    return verifier;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrOAuthSignatureFor:withKey                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)flickrOAuthSignatureFor:(NSString*)dataString withKey:(NSString*)secret
{
    NSData* secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* keyBytes  = [secretData bytes];
    const void* dataBytes = [stringData bytes];
    void* outputBuffer = malloc( CC_SHA1_DIGEST_LENGTH );
    CCHmac( kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outputBuffer );
    
    NSData* signatureData = [NSData dataWithBytesNoCopy:outputBuffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    return [signatureData base64EncodedStringWithOptions:0];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  sortedURLStringFromDictionary:urlEscape:                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)sortedURLStringFromDictionary:(NSDictionary*)dictionary urlEscape:(BOOL)urlEscape
{
    NSMutableArray* pairs = [NSMutableArray array];
    NSArray*        keys  = [[dictionary allKeys] sortedArrayUsingSelector:@selector( compare: )];
    
    for( NSString* key in keys )
    {
        NSString* value = [dictionary objectForKey:key];
        CFStringRef escapedValue = CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)value, NULL, CFSTR( "%:/?#[]@!$&'()*+,;=" ), kCFStringEncodingUTF8 );
        NSMutableString* pair = [key mutableCopy];
        [pair appendString:@"="];
        [pair appendString:(__bridge NSString*)escapedValue];
        [pairs addObject:pair];
        CFRelease( escapedValue );
    }
    NSString* URLString = (currentState == FlickrOAuthStateRequestToken ) ? kRequestTokenBaseURL : kAccessTokenBaseURL;
    if( urlEscape ) URLString = [URLString stringByAddingURLEncoding];
    
    NSMutableString* sortedUrl = [URLString mutableCopy];
    [sortedUrl appendString:( urlEscape ? @"&" : @"?" ) ];
    NSString *args = [pairs componentsJoinedByString:@"&"];
    if( urlEscape ) { args = [args stringByAddingURLEncoding]; }
    [sortedUrl appendString:args];
    
    return sortedUrl;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  handleCallBackURL:                                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)handleCallBackURL:(NSURL*)url
{
    currentState = FlickrOAuthStateAccessToken;
    
    NSString* nonce = [JMFUtility generateUuidString];
    NSString* timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString* verifier = [self extractVerifierFromURL:url];

    NSMutableDictionary* parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:nonce              forKey:@"oauth_nonce"];
    [parameters setValue:timestamp          forKey:@"oauth_timestamp"];
    [parameters setValue:verifier           forKey:@"oauth_verifier"];
    [parameters setValue:kFlickrConsumerKey forKey:@"oauth_consumer_key"];
    [parameters setValue:kSignatureMethod   forKey:@"oauth_signature_method"];
    [parameters setValue:kOAuthVersion      forKey:@"oauth_version"];
    [parameters setValue:self.token         forKey:@"oauth_token"];
    
    NSString* urlStringBeforeSignature = [self sortedURLStringFromDictionary:parameters urlEscape:YES];
    NSString* signature = [NSString stringWithFormat:@"GET&%@", urlStringBeforeSignature];
    NSString* signatureString = [self flickrOAuthSignatureFor:signature withKey:[NSString stringWithFormat:@"%@&%@", kFlickrConsumerSecret, self.tokenSecret]];
    [parameters setValue:signatureString forKey:@"oauth_signature"];
    NSString* urlStringWithSignature = [self sortedURLStringFromDictionary:parameters urlEscape:NO];

    receivedData = [NSMutableData data];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStringWithSignature]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

@end
