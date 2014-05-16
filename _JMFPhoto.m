// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFPhoto.m instead.

#import "_JMFPhoto.h"

const struct JMFPhotoAttributes JMFPhotoAttributes = {
	.altitude = @"altitude",
	.colorModel = @"colorModel",
	.colorsPerPixel = @"colorsPerPixel",
	.filteredImageUrl = @"filteredImageUrl",
	.filteredThumbnailUrl = @"filteredThumbnailUrl",
	.flickrPhotoId = @"flickrPhotoId",
	.geoLocation = @"geoLocation",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.orientation = @"orientation",
	.pixelHeight = @"pixelHeight",
	.pixelWidth = @"pixelWidth",
	.source = @"source",
	.sourceImageUrl = @"sourceImageUrl",
	.sourceThumbnailUrl = @"sourceThumbnailUrl",
	.uploaded = @"uploaded",
	.uploadedDate = @"uploadedDate",
};

const struct JMFPhotoRelationships JMFPhotoRelationships = {
	.faces = @"faces",
	.filters = @"filters",
};

const struct JMFPhotoFetchedProperties JMFPhotoFetchedProperties = {
};

@implementation JMFPhotoID
@end

@implementation _JMFPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (JMFPhotoID*)objectID {
	return (JMFPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"altitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"altitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"colorsPerPixelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"colorsPerPixel"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orientationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orientation"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pixelHeightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pixelHeight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pixelWidthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pixelWidth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sourceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"source"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"uploadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"uploaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic altitude;



- (double)altitudeValue {
	NSNumber *result = [self altitude];
	return [result doubleValue];
}

- (void)setAltitudeValue:(double)value_ {
	[self setAltitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveAltitudeValue {
	NSNumber *result = [self primitiveAltitude];
	return [result doubleValue];
}

- (void)setPrimitiveAltitudeValue:(double)value_ {
	[self setPrimitiveAltitude:[NSNumber numberWithDouble:value_]];
}





@dynamic colorModel;






@dynamic colorsPerPixel;



- (int16_t)colorsPerPixelValue {
	NSNumber *result = [self colorsPerPixel];
	return [result shortValue];
}

- (void)setColorsPerPixelValue:(int16_t)value_ {
	[self setColorsPerPixel:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveColorsPerPixelValue {
	NSNumber *result = [self primitiveColorsPerPixel];
	return [result shortValue];
}

- (void)setPrimitiveColorsPerPixelValue:(int16_t)value_ {
	[self setPrimitiveColorsPerPixel:[NSNumber numberWithShort:value_]];
}





@dynamic filteredImageUrl;






@dynamic filteredThumbnailUrl;






@dynamic flickrPhotoId;






@dynamic geoLocation;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic orientation;



- (int16_t)orientationValue {
	NSNumber *result = [self orientation];
	return [result shortValue];
}

- (void)setOrientationValue:(int16_t)value_ {
	[self setOrientation:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrientationValue {
	NSNumber *result = [self primitiveOrientation];
	return [result shortValue];
}

- (void)setPrimitiveOrientationValue:(int16_t)value_ {
	[self setPrimitiveOrientation:[NSNumber numberWithShort:value_]];
}





@dynamic pixelHeight;



- (int32_t)pixelHeightValue {
	NSNumber *result = [self pixelHeight];
	return [result intValue];
}

- (void)setPixelHeightValue:(int32_t)value_ {
	[self setPixelHeight:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePixelHeightValue {
	NSNumber *result = [self primitivePixelHeight];
	return [result intValue];
}

- (void)setPrimitivePixelHeightValue:(int32_t)value_ {
	[self setPrimitivePixelHeight:[NSNumber numberWithInt:value_]];
}





@dynamic pixelWidth;



- (int32_t)pixelWidthValue {
	NSNumber *result = [self pixelWidth];
	return [result intValue];
}

- (void)setPixelWidthValue:(int32_t)value_ {
	[self setPixelWidth:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePixelWidthValue {
	NSNumber *result = [self primitivePixelWidth];
	return [result intValue];
}

- (void)setPrimitivePixelWidthValue:(int32_t)value_ {
	[self setPrimitivePixelWidth:[NSNumber numberWithInt:value_]];
}





@dynamic source;



- (int16_t)sourceValue {
	NSNumber *result = [self source];
	return [result shortValue];
}

- (void)setSourceValue:(int16_t)value_ {
	[self setSource:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSourceValue {
	NSNumber *result = [self primitiveSource];
	return [result shortValue];
}

- (void)setPrimitiveSourceValue:(int16_t)value_ {
	[self setPrimitiveSource:[NSNumber numberWithShort:value_]];
}





@dynamic sourceImageUrl;






@dynamic sourceThumbnailUrl;






@dynamic uploaded;



- (BOOL)uploadedValue {
	NSNumber *result = [self uploaded];
	return [result boolValue];
}

- (void)setUploadedValue:(BOOL)value_ {
	[self setUploaded:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUploadedValue {
	NSNumber *result = [self primitiveUploaded];
	return [result boolValue];
}

- (void)setPrimitiveUploadedValue:(BOOL)value_ {
	[self setPrimitiveUploaded:[NSNumber numberWithBool:value_]];
}





@dynamic uploadedDate;






@dynamic faces;

	
- (NSMutableSet*)facesSet {
	[self willAccessValueForKey:@"faces"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"faces"];
  
	[self didAccessValueForKey:@"faces"];
	return result;
}
	

@dynamic filters;

	
- (NSMutableSet*)filtersSet {
	[self willAccessValueForKey:@"filters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"filters"];
  
	[self didAccessValueForKey:@"filters"];
	return result;
}
	






@end
