/***************************************************************************/
/*                                                                         */
/*  JMFPhoto.m                                                             */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData Photo Entity Class implementation file           */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Generated by mogenerator                                  */
/*                                                                         */
/***************************************************************************/
#import "JMFPhoto.h"
#import "JMFNamedEntity.h"
#import "JMFUtility.h"
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFPhoto Class Interface                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFPhoto ()

- (void)setMetadataFromImage:(UIImage*)image;
- (void)saveImageFile:(UIImage*)image withTumbnail:(UIImage*)thumbnail;

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFPhoto Class implementation                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFPhoto


#pragma mark - Key Value Observing Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Key Value Observing Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  observableKeys                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSArray*)observableKeys
{
    return @[JMFNamedEntityAttributes.name, JMFNamedEntityAttributes.creationDate, JMFPhotoRelationships.photo2faces, JMFPhotoRelationships.photo2filters];
}

#pragma mark - Initialization Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  photoWithImage:source:thumbnail:inContext:                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (instancetype)photoWithImage:(UIImage*)image source:(JMFPhotoSource)source thumbnail:(UIImage*)thumbnail inContext:(NSManagedObjectContext*)context
{
    JMFPhoto* photo = [JMFPhoto insertInManagedObjectContext:context];
    
    photo.name = [JMFUtility generateNewImageFileName];
    photo.creationDate = photo.modificationDate = [NSDate date];
    
    photo.source = [NSNumber numberWithInt:source];
    photo.sourceImageUrl = photo.sourceThumbnailUrl = nil;
    photo.filteredImageUrl = photo.filteredThumbnailUrl = @"";//nil;
    photo.altitude = photo.longitude = photo.latitude = @0;//nil;
    photo.geoLocation = photo.colorModel = @"";
    photo.colorsPerPixel = photo.orientation = nil;
    photo.pixelHeight = photo.pixelWidth = nil;
    
    [photo setMetadataFromImage:image];
    [photo saveImageFile:image withTumbnail:thumbnail];
    
    return photo;
}

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
/*  setLocationLongitude:latitude:altitude:geoLocation:                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setLocationLongitude:(NSNumber*)longitude latitude:(NSNumber*)latitude altitude:(NSNumber*)altitude geoLocation:(NSString*)geoLocation
{
    if( longitude != nil   ) self.longitude   = longitude;
    if( latitude != nil    ) self.latitude    = latitude;
    if( altitude != nil    ) self.altitude    = altitude;
    if( geoLocation != nil ) self.geoLocation = geoLocation;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  sourceFromNumber:                                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)sourceFromNumber:(NSNumber*)source
{
    NSArray* sourceStrings = @[@"IDS_UNKNOWN", @"IDS_CAMERA", @"IDS_FLICKR", @"IDS_FACEBOOK", @"IDS_INSTAGRAM", @"IDS_TWITTER", @"IDS_OTHER" ];
    NSString* sourceDescription = nil;
    
    if( [source intValue] >= JMFPhotoSourceUnknown && [source intValue] <= JMFPhotoSourceOther )
    {
        sourceDescription = NSLocalizedString( [sourceStrings objectAtIndex:[source intValue]], nil );
    }
    else sourceDescription = NSLocalizedString( @"IDS_UNKNOWN", nil );
    return sourceDescription;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  orientationFromNumber:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)orientationFromNumber:(NSNumber*)orientation
{
    NSArray* orientationStrings = @[@"IDS_UNKNOWN", @"IDS_TOPLEFT", @"IDS_TOPRIGHT", @"IDS_BOTTOMRIGHT",
                                    @"IDS_BOTOMLEFT", @"IDS_LEFTTOP", @"IDS_RIGHTTOP", @"RIGHTBOTTOM", @"LEFTBOTTOM" ];
    NSString* orientationDescription = nil;
    
    if( [orientation intValue] >= 1 && [orientation intValue] <= 8 )
    {
        orientationDescription = NSLocalizedString( [orientationStrings objectAtIndex:[orientation intValue]], nil );
    }
    else orientationDescription = NSLocalizedString( @"IDS_UNKNOWN", nil );
    return orientationDescription;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  setMetadataFromImage:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setMetadataFromImage:(UIImage*)image
{
    NSData* imageData = UIImageJPEGRepresentation( image, 0.8f );
    if( imageData == nil ) return;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData( (__bridge CFMutableDataRef)imageData, NULL );
    if( imageSource == nil ) return;
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO], (NSString*)kCGImageSourceShouldCache, nil];
    
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex( imageSource, 0, (__bridge CFDictionaryRef)options);
    if( imageProperties )
    {
        self.colorModel        = (NSString*)CFDictionaryGetValue( imageProperties, kCGImagePropertyColorModel  );
        self.colorsPerPixel    = (NSNumber*)CFDictionaryGetValue( imageProperties, kCGImagePropertyDepth       );
        self.orientation       = (NSNumber*)CFDictionaryGetValue( imageProperties, kCGImagePropertyOrientation );
        self.pixelHeight       = (NSNumber*)CFDictionaryGetValue( imageProperties, kCGImagePropertyPixelHeight );
        self.pixelWidth        = (NSNumber*)CFDictionaryGetValue( imageProperties, kCGImagePropertyPixelWidth  );
        CFRelease( imageProperties );
    }
    CFRelease( imageSource );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  saveImageFile:withTumbnail:                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)saveImageFile:(UIImage*)image withTumbnail:(UIImage*)thumbnail
{
    if( image == nil ) return;
    
    self.sourceImageUrl     = [JMFUtility pathForImageFileName:self.name];
    self.sourceThumbnailUrl = [JMFUtility pathForThumbnailFileName:self.name];
    
    if( thumbnail == nil )
    {
        CGSize destinationSize = CGSizeMake( [self.pixelWidth integerValue] / 4, [self.pixelHeight integerValue] / 4 );
        UIGraphicsBeginImageContext( destinationSize );
        [image drawInRect:CGRectMake( 0, 0, destinationSize.width, destinationSize.height ) ];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [UIImageJPEGRepresentation( image, 1.0 ) writeToFile:self.sourceImageUrl options:NSAtomicWrite error:nil];
    [UIImageJPEGRepresentation( thumbnail, 1.0 ) writeToFile:self.sourceThumbnailUrl options:NSAtomicWrite error:nil];
}

@end