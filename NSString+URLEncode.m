/***************************************************************************/
/*                                                                         */
/*  NSString+URLEncode.m                                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               NSString URLEncode Category Class implementation file     */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "NSString+URLEncode.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSString+URLEncode Category Class implementation                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation NSString (NMMURLEncodeString)

#pragma mark - Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  stringByAddingURLEncoding                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)stringByAddingURLEncoding
{
    static CFStringRef specialCharacters = CFSTR( "% /'\"?=&+<>;:!" );
    NSString* result = (NSString*)CFBridgingRelease( CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, specialCharacters, kCFStringEncodingUTF8 ) );
    return result;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  stringWithOAuthEncoding                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)stringWithOAuthEncoding
{
    NSMutableString *result = [NSMutableString string];
	const char* p = [self UTF8String];
	unsigned char c;
	
	for( ; ( c = *p ); p++ )
	{
		switch( c )
		{
			case '0' ... '9':
			case 'A' ... 'Z':
			case 'a' ... 'z':
			case '.':
			case '-':
			case '~':
			case '_':
				[result appendFormat:@"%c", c];
				break;
			default:
				[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

@end