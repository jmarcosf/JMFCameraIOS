// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilterProperty.m instead.

#import "_JMFFilterProperty.h"

const struct JMFFilterPropertyAttributes JMFFilterPropertyAttributes = {
	.defaultValue = @"defaultValue",
	.max = @"max",
	.min = @"min",
	.step = @"step",
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
	
	if ([key isEqualToString:@"defaultValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"defaultValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stepValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"step"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic defaultValue;



- (float)defaultValueValue {
	NSNumber *result = [self defaultValue];
	return [result floatValue];
}

- (void)setDefaultValueValue:(float)value_ {
	[self setDefaultValue:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDefaultValueValue {
	NSNumber *result = [self primitiveDefaultValue];
	return [result floatValue];
}

- (void)setPrimitiveDefaultValueValue:(float)value_ {
	[self setPrimitiveDefaultValue:[NSNumber numberWithFloat:value_]];
}





@dynamic max;



- (float)maxValue {
	NSNumber *result = [self max];
	return [result floatValue];
}

- (void)setMaxValue:(float)value_ {
	[self setMax:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveMaxValue {
	NSNumber *result = [self primitiveMax];
	return [result floatValue];
}

- (void)setPrimitiveMaxValue:(float)value_ {
	[self setPrimitiveMax:[NSNumber numberWithFloat:value_]];
}





@dynamic min;



- (float)minValue {
	NSNumber *result = [self min];
	return [result floatValue];
}

- (void)setMinValue:(float)value_ {
	[self setMin:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveMinValue {
	NSNumber *result = [self primitiveMin];
	return [result floatValue];
}

- (void)setPrimitiveMinValue:(float)value_ {
	[self setPrimitiveMin:[NSNumber numberWithFloat:value_]];
}





@dynamic step;



- (float)stepValue {
	NSNumber *result = [self step];
	return [result floatValue];
}

- (void)setStepValue:(float)value_ {
	[self setStep:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveStepValue {
	NSNumber *result = [self primitiveStep];
	return [result floatValue];
}

- (void)setPrimitiveStepValue:(float)value_ {
	[self setPrimitiveStep:[NSNumber numberWithFloat:value_]];
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
