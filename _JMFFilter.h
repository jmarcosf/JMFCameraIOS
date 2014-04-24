// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFilter.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFFilterAttributes {
	__unsafe_unretained NSString *active;
	__unsafe_unretained NSString *name;
} JMFFilterAttributes;

extern const struct JMFFilterRelationships {
	__unsafe_unretained NSString *filter2photo;
} JMFFilterRelationships;

extern const struct JMFFilterFetchedProperties {
} JMFFilterFetchedProperties;

@class JMFPhoto;




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





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JMFPhoto *filter2photo;

//- (BOOL)validateFilter2photo:(id*)value_ error:(NSError**)error_;





@end

@interface _JMFFilter (CoreDataGeneratedAccessors)

@end

@interface _JMFFilter (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(NSNumber*)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (JMFPhoto*)primitiveFilter2photo;
- (void)setPrimitiveFilter2photo:(JMFPhoto*)value;


@end
