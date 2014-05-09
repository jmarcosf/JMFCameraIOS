// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilter.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFFilterAttributes {
	__unsafe_unretained NSString *active;
	__unsafe_unretained NSString *position;
} JMFFilterAttributes;

extern const struct JMFFilterRelationships {
	__unsafe_unretained NSString *photo;
	__unsafe_unretained NSString *properties;
} JMFFilterRelationships;

extern const struct JMFFilterFetchedProperties {
} JMFFilterFetchedProperties;

@class JMFPhoto;
@class JMFFilterProperty;




@interface JMFFilterID : NSManagedObjectID {}
@end

@interface _JMFFilter : JMFNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JMFFilterID*)objectID;





@property (nonatomic, strong) NSNumber* active;



@property BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;

//- (BOOL)validateActive:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* position;



@property int32_t positionValue;
- (int32_t)positionValue;
- (void)setPositionValue:(int32_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JMFPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *properties;

- (NSMutableSet*)propertiesSet;





@end

@interface _JMFFilter (CoreDataGeneratedAccessors)

- (void)addProperties:(NSSet*)value_;
- (void)removeProperties:(NSSet*)value_;
- (void)addPropertiesObject:(JMFFilterProperty*)value_;
- (void)removePropertiesObject:(JMFFilterProperty*)value_;

@end

@interface _JMFFilter (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(NSNumber*)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;




- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int32_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int32_t)value_;





- (JMFPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(JMFPhoto*)value;



- (NSMutableSet*)primitiveProperties;
- (void)setPrimitiveProperties:(NSMutableSet*)value;


@end
