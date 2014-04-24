// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFace.m instead.

#import "_JMFFace.h"

const struct JMFFaceAttributes JMFFaceAttributes = {
	.faceRect = @"faceRect",
	.leftEyePoint = @"leftEyePoint",
	.mouthPoint = @"mouthPoint",
	.rightEyePoint = @"rightEyePoint",
};

const struct JMFFaceRelationships JMFFaceRelationships = {
	.face2photo = @"face2photo",
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
	

	return keyPaths;
}




@dynamic faceRect;






@dynamic leftEyePoint;






@dynamic mouthPoint;






@dynamic rightEyePoint;






@dynamic face2photo;

	






@end
