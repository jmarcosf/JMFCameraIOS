/***************************************************************************/
/*                                                                         */
/*  JMFFlickrUploadResponse.m                                              */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Upload Photo Response Class implementation file    */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFFlickrUploadResponse.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrUploadResponse Interface Definition                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrUploadResponse ()
{
    NSMutableString*    currentElementContent;
    NSData*             responseData;
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
@implementation JMFFlickrUploadResponse

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
/*  initWithData:                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithData:(NSData*)data
{
    self = [super init];
    if( self )
    {
        responseData = data;
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  parse:                                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)parse
{
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	return [xmlParser parse];
}

#pragma mark - NSXMLParserDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSXMLParserDelegate Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  parser:didStartElement:namespaceURI:qualifiedName:attributes:          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	currentElementContent = nil;
	BOOL success = NO;
    
	if( [elementName isEqualToString:@"rsp"] )
    {
		NSString* status = [attributeDict objectForKey:@"stat"];
        
        if( [status isEqualToString:@"ok"] ) success = YES;
		else if( [status isEqualToString:@"fail"] )success = NO;
	}
	
	if( [elementName isEqualToString:@"err"] )
    {
		NSString* errorCodeString  = [attributeDict objectForKey:@"code"];
		NSString* errorDescription = [attributeDict objectForKey:@"msg"];
		NSInteger errorCode = [errorCodeString integerValue];
		NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorDescription};
		NSError* error = [NSError errorWithDomain:@"JMFFlickrUploadDomain" code:errorCode userInfo:userInfo];
		self.error = error;
	}
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  parser:foundCharacters:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    if( !currentElementContent ) currentElementContent = [[NSMutableString alloc] initWithCapacity:50];
    [currentElementContent appendString:string];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  parser:didEndElement:namespaceURI:qualifiedName:                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"photoid"] ) self.photoId = [currentElementContent copy];
}

@end
