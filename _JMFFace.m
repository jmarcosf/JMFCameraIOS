// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFace.m instead.

#import "_JMFFace.h"

const struct JMFFaceAttributes JMFFaceAttributes = {
	.faceRect = @"faceRect",
	.flags = @"flags",
	.leftEyePoint = @"leftEyePoint",
	.mouthPoint = @"mouthPoint",
	.rightEyePoint = @"rightEyePoint",
};

const struct JMFFaceRelationships JMFFaceRelationships = {
	.photo = @"photo",
};

const struct JMFFaceFetchedProperties JMFFaceFetchedProperties = {
};

@implementation JMFFaceID
@end

@implementation _JMFFace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Face" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Face";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Face" inManagedObjectContext:moc_];
}

- (JMFFaceID*)objectID {
	return (JMFFaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"flagsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"flags"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic faceRect;






@dynamic flags;



- (int32_t)flagsValue {
	NSNumber *result = [self flags];
	return [result intValue];
}

- (void)setFlagsValue:(int32_t)value_ {
	[self setFlags:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFlagsValue {
	NSNumber *result = [self primitiveFlags];
	return [result intValue];
}

- (void)setPrimitiveFlagsValue:(int32_t)value_ {
	[self setPrimitiveFlags:[NSNumber numberWithInt:value_]];
}





@dynamic leftEyePoint;






@dynamic mouthPoint;






@dynamic rightEyePoint;






@dynamic photo;

	






@end
