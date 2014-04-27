// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFPhoto.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFPhotoAttributes {
	__unsafe_unretained NSString *altitude;
	__unsafe_unretained NSString *colorModel;
	__unsafe_unretained NSString *colorsPerPixel;
	__unsafe_unretained NSString *filteredImageUrl;
	__unsafe_unretained NSString *filteredThumbnailUrl;
	__unsafe_unretained NSString *geoLocation;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *orientation;
	__unsafe_unretained NSString *pixelHeight;
	__unsafe_unretained NSString *pixelWidth;
	__unsafe_unretained NSString *source;
	__unsafe_unretained NSString *sourceImageUrl;
	__unsafe_unretained NSString *sourceThumbnailUrl;
} JMFPhotoAttributes;

extern const struct JMFPhotoRelationships {
	__unsafe_unretained NSString *photo2faces;
	__unsafe_unretained NSString *photo2filters;
} JMFPhotoRelationships;

extern const struct JMFPhotoFetchedProperties {
} JMFPhotoFetchedProperties;

@class JMFFace;
@class JMFFilter;
















@interface JMFPhotoID : NSManagedObjectID {}
@end

@interface _JMFPhoto : JMFNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JMFPhotoID*)objectID;





@property (nonatomic, strong) NSNumber* altitude;



@property double altitudeValue;
- (double)altitudeValue;
- (void)setAltitudeValue:(double)value_;

//- (BOOL)validateAltitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* colorModel;



//- (BOOL)validateColorModel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* colorsPerPixel;



@property int16_t colorsPerPixelValue;
- (int16_t)colorsPerPixelValue;
- (void)setColorsPerPixelValue:(int16_t)value_;

//- (BOOL)validateColorsPerPixel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* filteredImageUrl;



//- (BOOL)validateFilteredImageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* filteredThumbnailUrl;



//- (BOOL)validateFilteredThumbnailUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* geoLocation;



//- (BOOL)validateGeoLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* orientation;



@property int16_t orientationValue;
- (int16_t)orientationValue;
- (void)setOrientationValue:(int16_t)value_;

//- (BOOL)validateOrientation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pixelHeight;



@property int32_t pixelHeightValue;
- (int32_t)pixelHeightValue;
- (void)setPixelHeightValue:(int32_t)value_;

//- (BOOL)validatePixelHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pixelWidth;



@property int32_t pixelWidthValue;
- (int32_t)pixelWidthValue;
- (void)setPixelWidthValue:(int32_t)value_;

//- (BOOL)validatePixelWidth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* source;



@property int16_t sourceValue;
- (int16_t)sourceValue;
- (void)setSourceValue:(int16_t)value_;

//- (BOOL)validateSource:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sourceImageUrl;



//- (BOOL)validateSourceImageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sourceThumbnailUrl;



//- (BOOL)validateSourceThumbnailUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *photo2faces;

- (NSMutableSet*)photo2facesSet;




@property (nonatomic, strong) NSSet *photo2filters;

- (NSMutableSet*)photo2filtersSet;





@end

@interface _JMFPhoto (CoreDataGeneratedAccessors)

- (void)addPhoto2faces:(NSSet*)value_;
- (void)removePhoto2faces:(NSSet*)value_;
- (void)addPhoto2facesObject:(JMFFace*)value_;
- (void)removePhoto2facesObject:(JMFFace*)value_;

- (void)addPhoto2filters:(NSSet*)value_;
- (void)removePhoto2filters:(NSSet*)value_;
- (void)addPhoto2filtersObject:(JMFFilter*)value_;
- (void)removePhoto2filtersObject:(JMFFilter*)value_;

@end

@interface _JMFPhoto (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAltitude;
- (void)setPrimitiveAltitude:(NSNumber*)value;

- (double)primitiveAltitudeValue;
- (void)setPrimitiveAltitudeValue:(double)value_;




- (NSString*)primitiveColorModel;
- (void)setPrimitiveColorModel:(NSString*)value;




- (NSNumber*)primitiveColorsPerPixel;
- (void)setPrimitiveColorsPerPixel:(NSNumber*)value;

- (int16_t)primitiveColorsPerPixelValue;
- (void)setPrimitiveColorsPerPixelValue:(int16_t)value_;




- (NSString*)primitiveFilteredImageUrl;
- (void)setPrimitiveFilteredImageUrl:(NSString*)value;




- (NSString*)primitiveFilteredThumbnailUrl;
- (void)setPrimitiveFilteredThumbnailUrl:(NSString*)value;




- (NSString*)primitiveGeoLocation;
- (void)setPrimitiveGeoLocation:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSNumber*)primitiveOrientation;
- (void)setPrimitiveOrientation:(NSNumber*)value;

- (int16_t)primitiveOrientationValue;
- (void)setPrimitiveOrientationValue:(int16_t)value_;




- (NSNumber*)primitivePixelHeight;
- (void)setPrimitivePixelHeight:(NSNumber*)value;

- (int32_t)primitivePixelHeightValue;
- (void)setPrimitivePixelHeightValue:(int32_t)value_;




- (NSNumber*)primitivePixelWidth;
- (void)setPrimitivePixelWidth:(NSNumber*)value;

- (int32_t)primitivePixelWidthValue;
- (void)setPrimitivePixelWidthValue:(int32_t)value_;




- (NSNumber*)primitiveSource;
- (void)setPrimitiveSource:(NSNumber*)value;

- (int16_t)primitiveSourceValue;
- (void)setPrimitiveSourceValue:(int16_t)value_;




- (NSString*)primitiveSourceImageUrl;
- (void)setPrimitiveSourceImageUrl:(NSString*)value;




- (NSString*)primitiveSourceThumbnailUrl;
- (void)setPrimitiveSourceThumbnailUrl:(NSString*)value;





- (NSMutableSet*)primitivePhoto2faces;
- (void)setPrimitivePhoto2faces:(NSMutableSet*)value;



- (NSMutableSet*)primitivePhoto2filters;
- (void)setPrimitivePhoto2filters:(NSMutableSet*)value;


@end
