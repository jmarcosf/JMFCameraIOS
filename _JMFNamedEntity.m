// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFNamedEntity.m instead.

#import "_JMFNamedEntity.h"

const struct JMFNamedEntityAttributes JMFNamedEntityAttributes = {
	.creationDate = @"creationDate",
	.modificationDate = @"modificationDate",
};

const struct JMFNamedEntityRelationships JMFNamedEntityRelationships = {
};

const struct JMFNamedEntityFetchedProperties JMFNamedEntityFetchedProperties = {
};

@implementation JMFNamedEntityID
@end

@implementation _JMFNamedEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NamedEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NamedEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NamedEntity" inManagedObjectContext:moc_];
}

- (JMFNamedEntityID*)objectID {
	return (JMFNamedEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic creationDate;






@dynamic modificationDate;











@end
