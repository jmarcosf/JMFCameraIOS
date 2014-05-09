// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilter.m instead.

#import "_JMFFilter.h"

const struct JMFFilterAttributes JMFFilterAttributes = {
	.active = @"active",
	.position = @"position",
};

const struct JMFFilterRelationships JMFFilterRelationships = {
	.photo = @"photo",
	.properties = @"properties",
};

const struct JMFFilterFetchedProperties JMFFilterFetchedProperties = {
};

@implementation JMFFilterID
@end

@implementation _JMFFilter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Filter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Filter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Filter" inManagedObjectContext:moc_];
}

- (JMFFilterID*)objectID {
	return (JMFFilterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic active;



- (BOOL)activeValue {
	NSNumber *result = [self active];
	return [result boolValue];
}

- (void)setActiveValue:(BOOL)value_ {
	[self setActive:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveActiveValue {
	NSNumber *result = [self primitiveActive];
	return [result boolValue];
}

- (void)setPrimitiveActiveValue:(BOOL)value_ {
	[self setPrimitiveActive:[NSNumber numberWithBool:value_]];
}





@dynamic position;



- (int32_t)positionValue {
	NSNumber *result = [self position];
	return [result intValue];
}

- (void)setPositionValue:(int32_t)value_ {
	[self setPosition:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePositionValue {
	NSNumber *result = [self primitivePosition];
	return [result intValue];
}

- (void)setPrimitivePositionValue:(int32_t)value_ {
	[self setPrimitivePosition:[NSNumber numberWithInt:value_]];
}





@dynamic photo;

	

@dynamic properties;

	
- (NSMutableSet*)propertiesSet {
	[self willAccessValueForKey:@"properties"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"properties"];
  
	[self didAccessValueForKey:@"properties"];
	return result;
}
	






@end
