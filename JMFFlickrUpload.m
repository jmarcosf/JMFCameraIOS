/***************************************************************************/
/*                                                                         */
/*  JMFFlickrUpload.m                                                      */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Upload Photo Class implementation file             */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <CommonCrypto/CommonHMAC.h>
#import "JMFFlickrUpload.h"
#import "JMFAppDelegate.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Constants                                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static NSString* kFlickrUploadUrl             = @"https://up.flickr.com/services/upload/";
static NSString* kEscapeChars                 = @"`~!@#$^&*()=+[]\\{}|;':\",/<>?";
static unsigned char base64EncodeLookup[ 65 ] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define BINARY_UNIT_SIZE                    3
#define BASE64_UNIT_SIZE                    4
#define CR_LF_SIZE                          2
#define OUTPUT_LINE_LENGTH                  64
#define INPUT_LINE_LENGTH                   ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUpload Interface Definition                                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrUpload ()
{
    NSMutableData*              responseData;
    NSString*                   tempFileName;
    NSURLSession*               backgroundSession;
    NSURLSessionUploadTask*     uploadTask;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUpload Class Implementation                                   */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFlickrUpload

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
/*  initWithToken:tokenSecret:delegate:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithToken:(NSString*)token tokenSecret:(NSString*)tokenSecret delegate:(id< JMFFlickrUploadDelegate >)delegate
{
    if( self = [super init] )
    {
        self.token       = token;
        self.tokenSecret = tokenSecret;
        self.delegate    = delegate;
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  uploadImage:title:description:fileName:                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)uploadImage:(UIImage*)image title:(NSString*)title description:(NSString*)description fileName:(NSString*)fileName
{
    responseData = [NSMutableData data];
    [self setTempFileName];

    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.utad.jmfcameraios"];
    sessionConfig.HTTPAdditionalHeaders = @{ @"Accept" : @"text/xml" };
    backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kFlickrUploadUrl]];
    [request setHTTPMethod:@"POST"];
    [self generateBodyFileForUploadImage:image title:title description:description fileName:fileName request:request];
    
    NSURL* fileUrl = [[NSURL alloc]initFileURLWithPath:tempFileName];
    NSURLSessionUploadTask* task = [backgroundSession uploadTaskWithRequest:request fromFile:fileUrl];
                                    
    [task resume];
}

#pragma mark - NSURLSessionDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSURLSessionDelegate Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* URLSessionDidFinishEventsForBackgroundURLSession:                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession*)session
{
    JMFAppDelegate* appDelegate = (JMFAppDelegate*)[[UIApplication sharedApplication] delegate];
    if( appDelegate.backgroundSessionCompletionHandler )
    {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    
//  NSLog( @"All tasks are finished" );
}

#pragma mark - NSURLSessionTaskDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSURLSessionTaskDelegate Methods                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:*/
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    float progress = ( (float)totalBytesSent * 1.0f ) / ( (float)totalBytesExpectedToSend * 1.0f );
    
    if( [self.delegate respondsToSelector:@selector( flickrUpload:progress: )] )
    {
        [self.delegate flickrUpload:self progress:progress];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  URLSession:task:didCompleteWithError:                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{
    [JMFUtility deleteFileAtPath:tempFileName];
    
    JMFFlickrUploadResponse* response = nil;
    if( !error )
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
        if( httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 )
        {
            response = [[JMFFlickrUploadResponse alloc]initWithData:responseData];
            [response parse];
        }
        else error = [NSError errorWithDomain:@"jmfcameraios"
                                         code:httpResponse.statusCode
                                     userInfo:@{[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode] : @"ErrorDescription"}];
    }
    
    if( [self.delegate respondsToSelector:@selector( flickrDidFinishUpload:response:error: )] )
    {
        [self.delegate flickrDidFinishUpload:self response:response error:error];
    }
}


#pragma mark - NSURLSessionDataDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSURLSessionDataDelegate Methods                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* URLSession:dataTask:didReceiveData:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
{
    [responseData appendData:data];
}

#pragma mark - Class Private Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Private Methods                                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setTempFileName                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setTempFileName
{
	tempFileName = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.%@", @"FlickrTempFile", @"bin"];
    [JMFUtility deleteFileAtPath:tempFileName];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/* generateBodyFileForUploadImage:title:description:filename:request:      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)generateBodyFileForUploadImage:(UIImage*)image title:(NSString*)title description:(NSString*)description fileName:(NSString*)fileName request:(NSMutableURLRequest*)request
{
    //Parameters
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:title       forKey:@"title"];
    [parameters setValue:description forKey:@"description"];
    [parameters setValue:@"json"     forKey:@"format"];
    NSDictionary* signedParameters = [self signedArgsFromParameters:parameters baseURL:[NSURL URLWithString:kFlickrUploadUrl] method:@"POST"];
	
	// HTTP POST Multipart Form
	NSString* boundary = [JMFUtility generateUuidString];
	NSMutableString* multiPart = [NSMutableString string];
    
	for (NSString *key in signedParameters.allKeys)
    {
		[multiPart appendFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", boundary, key, [signedParameters valueForKey:key]];
	}
    [multiPart appendFormat:@"--%@\r\nContent-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n", boundary, fileName];
    [multiPart appendFormat:@"Content-Type: %@\r\n\r\n", @"image/jpg"];
	
	NSMutableString* multipartFooter = [NSMutableString string];
	[multipartFooter appendFormat:@"\r\n--%@--", boundary];
    
	// Copy image to temp file
	NSInputStream*  imageStream  = [[NSInputStream alloc] initWithData:UIImageJPEGRepresentation( image, 1.0 )];
    NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:tempFileName append:NO];
    [outputStream open];
	[self writeMultipart:multiPart imageStream:imageStream outputStream:outputStream footer:multipartFooter];
    
    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Get the file size
    NSError* error;
    NSDictionary* fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:tempFileName error:&error];
    NSNumber* fileSize = [fileInfo objectForKey:NSFileSize];
    [request setValue:[fileSize stringValue] forHTTPHeaderField:@"Content-Length"];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  signedArgsFromParameters:baseURL:method:                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSDictionary*)signedArgsFromParameters:(NSDictionary*)unsignedParameters baseURL:(NSURL *)inURL method:(NSString*)method
{
    NSMutableDictionary* signedParameters = [NSMutableDictionary dictionaryWithDictionary:unsignedParameters];
    
    NSString* nonce        = [[JMFUtility generateUuidString] substringToIndex:8];
  	NSString* timestamp    = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSString* signatureKey = [NSString stringWithFormat:@"%@&%@", kFlickrConsumerSecret, self.tokenSecret];
    
    [signedParameters setValue:nonce              forKey:@"oauth_nonce"];
    [signedParameters setValue:timestamp          forKey:@"oauth_timestamp"];
    [signedParameters setValue:kOAuthVersion      forKey:@"oauth_version"];
    [signedParameters setValue:kSignatureMethod   forKey:@"oauth_signature_method"];
    [signedParameters setValue:kFlickrConsumerKey forKey:@"oauth_consumer_key"];
    [signedParameters setValue:self.token         forKey:@"oauth_token"];

    NSMutableString* baseString = [NSMutableString string];
    [baseString appendString:method];
    [baseString appendString:@"&"];
    [baseString appendString:EscapedURLStringPlus( [inURL absoluteString] )];
    
    NSArray* sortedKeys = [[signedParameters allKeys] sortedArrayUsingSelector:@selector( compare: )];
    [baseString appendString:@"&"];
    
	NSMutableArray* baseStrArgs = [NSMutableArray array];
	for( NSString* key in sortedKeys )
    {
		[baseStrArgs addObject:[NSString stringWithFormat:@"%@=%@", key, EscapedURLStringPlus( signedParameters[ key ] )]];
	}
    
    [baseString appendString:EscapedURLStringPlus( [baseStrArgs componentsJoinedByString:@"&"] )];
    
    NSString* signature = OFHMACSha1Base64( signatureKey, baseString );
    [signedParameters setValue:signature forKey:@"oauth_signature"];
    
    return signedParameters;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  writeMultipart:imageStream:outputStream:footer:                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)writeMultipart:multipart imageStream:imageStream outputStream:outputStream footer:multipartFooter
{
    const char* UTF8String;
    size_t writeLength;
    
    //Write multipart to output stream
    UTF8String = [multipart UTF8String];
    writeLength = strlen( UTF8String );
	size_t __unused actualWrittenLength;
	actualWrittenLength = [outputStream write:(uint8_t*)UTF8String maxLength:writeLength];
    NSAssert( actualWrittenLength == writeLength, @"Error writing multipart to output stream" );
	
    if( imageStream )
    {
        // Copy image stream to output streams in 64Kb chuncks
        const size_t bufferSize = 65536;
        size_t readSize = 0;
        uint8_t* buffer = (uint8_t*)calloc( 1, bufferSize );
        NSAssert( buffer, @"Not enough memory" );
        
        [imageStream open];
        while( [imageStream hasBytesAvailable])
        {
            if( !( readSize = [imageStream read:buffer maxLength:bufferSize] ) ) break;
            
            size_t __unused actualWrittenLength;
            actualWrittenLength = [outputStream write:buffer maxLength:readSize];
            NSAssert( actualWrittenLength == readSize, @"Error reading Image Stream" );
        }
        [imageStream close];
        free( buffer );
    }
    
    // Write footer to output steream
    UTF8String = [multipartFooter UTF8String];
    writeLength = strlen( UTF8String );
	actualWrittenLength = [outputStream write:(uint8_t*)UTF8String maxLength:writeLength];
    NSAssert( actualWrittenLength == writeLength, @"Error writing multipart footer to output stream" );
    [outputStream close];
}

#pragma mark - Auxiliary C Functions
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Auxiliary C Functions                                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  EscapedURLStringPlus()                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
NSString* EscapedURLStringPlus( NSString* string )
{
	CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)string, NULL, (CFStringRef)kEscapeChars, kCFStringEncodingUTF8 );
	return( __bridge_transfer NSString* )escaped;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  OFSha1()                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static NSData* OFSha1( NSData* inputData )
{
    NSMutableData* result = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX context;
    CC_SHA1_Init( &context );
    CC_SHA1_Update( &context, [inputData bytes], (CC_LONG)[inputData length] );
    CC_SHA1_Final( [result mutableBytes], &context );
    return result;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  OFHMACSha1Base64()                                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
NSString* OFHMACSha1Base64( NSString* inputKey, NSString* inputMessage )
{
    NSData* keyData = [inputKey dataUsingEncoding:NSUTF8StringEncoding];
    
    if( [keyData length] > CC_SHA1_BLOCK_BYTES ) keyData = OFSha1( keyData );
    
    if( [keyData length] < CC_SHA1_BLOCK_BYTES )
    {
        NSUInteger padSize = CC_SHA1_BLOCK_BYTES - [keyData length];
        NSMutableData* paddedData = [NSMutableData dataWithData:keyData];
        [paddedData appendData:[NSMutableData dataWithLength:padSize]];
        keyData = paddedData;
    }

    NSMutableData* inputKeyPad  = [NSMutableData dataWithLength:CC_SHA1_BLOCK_BYTES];
    NSMutableData* outputKeyPad = [NSMutableData dataWithLength:CC_SHA1_BLOCK_BYTES];

    const uint8_t* keyDataPtr      = [keyData bytes];
    uint8_t*       outputKeyPadPtr = [outputKeyPad mutableBytes];
    uint8_t*       inputKeyPadPtr  = [inputKeyPad mutableBytes];
	
    memset( outputKeyPadPtr, 0x5c, CC_SHA1_BLOCK_BYTES );
    memset( inputKeyPadPtr, 0x36, CC_SHA1_BLOCK_BYTES );
    
    for( int i = 0; i < CC_SHA1_BLOCK_BYTES; i++ )
    {
        outputKeyPadPtr[ i ] = outputKeyPadPtr[ i ] ^ keyDataPtr[ i ];
        inputKeyPadPtr[ i ]  = inputKeyPadPtr[ i ]  ^ keyDataPtr[ i ];
    }
    
    NSData* messageData     = [inputMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData*innerData = [NSMutableData dataWithData:inputKeyPad];
    [innerData appendData:messageData];
    NSData* innerDataHashed = OFSha1( innerData );
    NSMutableData* outerData = [NSMutableData dataWithData:outputKeyPad];
    [outerData appendData:innerDataHashed];
    NSData* outerHashedData = OFSha1( outerData );
    
	size_t outputLength;
	char* outputBuffer = NewBase64Encode( [outerHashedData bytes], [outerHashedData length], true, &outputLength );
	NSString* result = [[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding];
	free( outputBuffer );
    
	return result;
}

#pragma mark - Base64Encode Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Base64Encode Methods                                                   */
/*                                                                         */
/*http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html/*/
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  NewBase64Encode()                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static char* NewBase64Encode( const void* buffer, size_t length, bool separateLines, size_t* outputLength )
{
	const unsigned char* inputBuffer = (const unsigned char*)buffer;
	
	// Byte accurate calculation of final buffer size
	size_t outputBufferSize = ( ( length / BINARY_UNIT_SIZE ) + ( ( length % BINARY_UNIT_SIZE ) ? 1 : 0 ) ) * BASE64_UNIT_SIZE;
	if (separateLines) outputBufferSize += ( outputBufferSize / OUTPUT_LINE_LENGTH ) * CR_LF_SIZE;
	
	// Include space for a terminating zero
	outputBufferSize += 1;
    
	// Allocate the output buffer
	char* outputBuffer = (char*)malloc( outputBufferSize );
	if (!outputBuffer) return NULL;
    
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while( true )
	{
		if( lineEnd > length ) lineEnd = length;
        
		for( ; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE )
		{
			// Inner loop: turn 48 bytes into 64 base64 characters
			outputBuffer[ j++ ] = base64EncodeLookup[ (inputBuffer[ i ] & 0xFC ) >> 2 ];
			outputBuffer[ j++ ] = base64EncodeLookup[ ( ( inputBuffer[ i     ] & 0x03 ) << 4 ) | ( ( inputBuffer[ i + 1 ] & 0xF0 ) >> 4 ) ];
			outputBuffer[ j++ ] = base64EncodeLookup[ ( ( inputBuffer[ i + 1 ] & 0x0F ) << 2 ) | ( ( inputBuffer[ i + 2 ] & 0xC0 ) >> 6 ) ];
			outputBuffer[ j++ ] = base64EncodeLookup[ inputBuffer[ i + 2 ] & 0x3F ];
		}
		
		if( lineEnd == length ) break;
		
		// Add the newline
		outputBuffer[ j++ ] = '\r';
		outputBuffer[ j++ ] = '\n';
		lineEnd += lineLength;
	}
	
	if( i + 1 < length )
	{
		// Handle the single '=' case
		outputBuffer[ j++ ] = base64EncodeLookup[ ( inputBuffer[ i ] & 0xFC )     >> 2 ];
		outputBuffer[ j++ ] = base64EncodeLookup[ ( ( inputBuffer[ i ] & 0x03 )   << 4 ) | ( ( inputBuffer[ i + 1 ] & 0xF0 ) >> 4 ) ];
		outputBuffer[ j++ ] = base64EncodeLookup[ ( inputBuffer[ i + 1 ] & 0x0F ) << 2 ];
		outputBuffer[ j++ ] = '=';
	}
	else if( i < length )
	{
		// Handle the double '=' case
		outputBuffer[ j++ ] = base64EncodeLookup[ ( inputBuffer[ i ] & 0xFC ) >> 2 ];
		outputBuffer[ j++ ] = base64EncodeLookup[ ( inputBuffer[ i ] & 0x03 ) << 4 ];
		outputBuffer[ j++ ] = '=';
		outputBuffer[ j++ ] = '=';
	}
	outputBuffer[ j ] = 0;
	
	// Set the output length and return the buffer
	if( outputLength ) *outputLength = j;
    
	return outputBuffer;
}

@end
