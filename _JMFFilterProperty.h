// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilterProperty.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFFilterPropertyAttributes {
	__unsafe_unretained NSString *value;
} JMFFilterPropertyAttributes;

extern const struct JMFFilterPropertyRelationships {
	__unsafe_unretained NSString *filter;
} JMFFilterPropertyRelationships;

extern const struct JMFFilterPropertyFetchedProperties {
} JMFFilterPropertyFetchedProperties;

@class JMFFilter;



@interface JMFFilterPropertyID : NSManagedObjectID {}
@end

@interface _JMFFilterProperty : JMFNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JMFFilterPropertyID*)objectID;





@property (nonatomic, strong) NSNumber* value;



@property float valueValue;
- (float)valueValue;
- (void)setValueValue:(float)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JMFFilter *filter;

//- (BOOL)validateFilter:(id*)value_ error:(NSError**)error_;





@end

@interface _JMFFilterProperty (CoreDataGeneratedAccessors)

@end

@interface _JMFFilterProperty (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (float)primitiveValueValue;
- (void)setPrimitiveValueValue:(float)value_;





- (JMFFilter*)primitiveFilter;
- (void)setPrimitiveFilter:(JMFFilter*)value;


@end
