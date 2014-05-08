// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilterProperty.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFFilterPropertyAttributes {
	__unsafe_unretained NSString *defaultValue;
	__unsafe_unretained NSString *max;
	__unsafe_unretained NSString *min;
	__unsafe_unretained NSString *step;
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





@property (nonatomic, strong) NSNumber* defaultValue;



@property float defaultValueValue;
- (float)defaultValueValue;
- (void)setDefaultValueValue:(float)value_;

//- (BOOL)validateDefaultValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* max;



@property float maxValue;
- (float)maxValue;
- (void)setMaxValue:(float)value_;

//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* min;



@property float minValue;
- (float)minValue;
- (void)setMinValue:(float)value_;

//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* step;



@property float stepValue;
- (float)stepValue;
- (void)setStepValue:(float)value_;

//- (BOOL)validateStep:(id*)value_ error:(NSError**)error_;





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


- (NSNumber*)primitiveDefaultValue;
- (void)setPrimitiveDefaultValue:(NSNumber*)value;

- (float)primitiveDefaultValueValue;
- (void)setPrimitiveDefaultValueValue:(float)value_;




- (NSNumber*)primitiveMax;
- (void)setPrimitiveMax:(NSNumber*)value;

- (float)primitiveMaxValue;
- (void)setPrimitiveMaxValue:(float)value_;




- (NSNumber*)primitiveMin;
- (void)setPrimitiveMin:(NSNumber*)value;

- (float)primitiveMinValue;
- (void)setPrimitiveMinValue:(float)value_;




- (NSNumber*)primitiveStep;
- (void)setPrimitiveStep:(NSNumber*)value;

- (float)primitiveStepValue;
- (void)setPrimitiveStepValue:(float)value_;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (float)primitiveValueValue;
- (void)setPrimitiveValueValue:(float)value_;





- (JMFFilter*)primitiveFilter;
- (void)setPrimitiveFilter:(JMFFilter*)value;


@end
