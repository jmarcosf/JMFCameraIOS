// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilterProperty.m instead.

#import "_JMFFilterProperty.h"

const struct JMFFilterPropertyAttributes JMFFilterPropertyAttributes = {
	.value = @"value",
};

const struct JMFFilterPropertyRelationships JMFFilterPropertyRelationships = {
	.filter = @"filter",
};

const struct JMFFilterPropertyFetchedProperties JMFFilterPropertyFetchedProperties = {
};

@implementation JMFFilterPropertyID
@end

@implementation _JMFFilterProperty

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FilterProperty" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FilterProperty";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FilterProperty" inManagedObjectContext:moc_];
}

- (JMFFilterPropertyID*)objectID {
	return (JMFFilterPropertyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic value;



- (float)valueValue {
	NSNumber *result = [self value];
	return [result floatValue];
}

- (void)setValueValue:(float)value_ {
	[self setValue:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result floatValue];
}

- (void)setPrimitiveValueValue:(float)value_ {
	[self setPrimitiveValue:[NSNumber numberWithFloat:value_]];
}





@dynamic filter;

	






@end
