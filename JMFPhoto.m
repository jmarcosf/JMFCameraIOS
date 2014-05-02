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
/*  Macros                                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define isValidFile( x )        ( x != nil && ![x isEqualToString:@""] )

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
    return @[JMFNamedEntityAttributes.name, JMFNamedEntityAttributes.creationDate, JMFPhotoRelationships.faces, JMFPhotoRelationships.filters];
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
    photo.source = [NSNumber numberWithInt:source];
    photo.sourceImageUrl = photo.sourceThumbnailUrl = nil;
    photo.filteredImageUrl = photo.filteredThumbnailUrl = @"";
    photo.altitude = photo.longitude = photo.latitude = @0;
    photo.geoLocation = photo.colorModel = @"";
    photo.colorsPerPixel = photo.orientation = nil;
    photo.pixelHeight = photo.pixelWidth = nil;
    
    [photo setMetadataFromImage:image];
    [photo saveSourceImage:image andTumbnail:thumbnail];
    
    return photo;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  awakeFromInsert                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void) awakeFromInsert
{
    [super awakeFromInsert];

    [self setCreationDate:[NSDate date]];
    [self setModificationDate:[NSDate date]];
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
/*  saveSourceImage:andTumbnail:                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)saveSourceImage:(UIImage*)image andTumbnail:(UIImage*)thumbnail;
{
    if( image == nil ) return;
    
    self.sourceImageUrl     = [JMFUtility pathForImageFileName:self.name];
    self.sourceThumbnailUrl = [JMFUtility pathForThumbnailFileName:self.name];

    [self saveImageFile:image toImageFileName:self.sourceImageUrl andTumbnail:thumbnail toThumbnailFileName:self.sourceThumbnailUrl];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  saveFilteredImage:andTumbnail:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)saveFilteredImage:(UIImage*)image andTumbnail:(UIImage*)thumbnail;
{
    if( image == nil ) return;
    
    self.filteredImageUrl     = [JMFUtility pathForFilteredImageFileName:self.name];
    self.filteredThumbnailUrl = [JMFUtility pathForFilteredThumbnailFileName:self.name];
    
    [self saveImageFile:image toImageFileName:self.filteredImageUrl andTumbnail:thumbnail toThumbnailFileName:self.filteredThumbnailUrl];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  saveImageFile:toImageFileName:andTumbnail:toThumbnailFileName:         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)saveImageFile:(UIImage*)image toImageFileName:(NSString*)imageFileName andTumbnail:(UIImage*)thumbnail toThumbnailFileName:(NSString*)thumbnailFileName;
{
    if( image == nil || imageFileName == nil || thumbnailFileName == nil ) return;
    
    if( thumbnail == nil )
    {
        CGSize destinationSize = CGSizeMake( [self.pixelWidth integerValue] / 4, [self.pixelHeight integerValue] / 4 );
        UIGraphicsBeginImageContext( destinationSize );
        [image drawInRect:CGRectMake( 0, 0, destinationSize.width, destinationSize.height ) ];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [UIImageJPEGRepresentation( image, 1.0 ) writeToFile:imageFileName options:NSAtomicWrite error:nil];
    [UIImageJPEGRepresentation( thumbnail, 1.0 ) writeToFile:thumbnailFileName options:NSAtomicWrite error:nil];
}

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
/*  sourceToString                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)sourceToString
{
    NSArray* sourceStrings = @[@"IDS_UNKNOWN", @"IDS_CAMERA", @"IDS_FLICKR", @"IDS_FACEBOOK", @"IDS_INSTAGRAM", @"IDS_TWITTER", @"IDS_OTHER" ];
    NSString* sourceDescription = nil;
    
    if( self.sourceValue >= JMFPhotoSourceUnknown && self.sourceValue <= JMFPhotoSourceOther )
    {
        sourceDescription = NSLocalizedString( [sourceStrings objectAtIndex:self.sourceValue], nil );
    }
    else sourceDescription = NSLocalizedString( @"IDS_UNKNOWN", nil );
    return sourceDescription;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  orientationToString                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)orientationToString
{
    NSArray* orientationStrings = @[@"IDS_UNKNOWN", @"IDS_TOPLEFT", @"IDS_TOPRIGHT", @"IDS_BOTTOMRIGHT",
                                    @"IDS_BOTOMLEFT", @"IDS_LEFTTOP", @"IDS_RIGHTTOP", @"RIGHTBOTTOM", @"LEFTBOTTOM" ];
    NSString* orientationDescription = nil;
    
    if( self.orientationValue >= 1 && self.orientationValue <= 8 )
    {
        orientationDescription = NSLocalizedString( [orientationStrings objectAtIndex:self.orientationValue], nil );
    }
    else orientationDescription = NSLocalizedString( @"IDS_UNKNOWN", nil );
    return orientationDescription;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  removeFiles                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)removeFiles
{
    NSError* error;
    if( isValidFile( self.sourceImageUrl       ) ) [[NSFileManager defaultManager]removeItemAtPath:self.sourceImageUrl error:&error];
    if( isValidFile( self.sourceThumbnailUrl   ) ) [[NSFileManager defaultManager]removeItemAtPath:self.sourceThumbnailUrl error:&error];
    if( isValidFile( self.filteredImageUrl     ) ) [[NSFileManager defaultManager]removeItemAtPath:self.filteredImageUrl error:&error];
    if( isValidFile( self.filteredThumbnailUrl ) ) [[NSFileManager defaultManager]removeItemAtPath:self.filteredThumbnailUrl error:&error];
}

@end