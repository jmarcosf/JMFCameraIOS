// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFNamedEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct JMFNamedEntityAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *modificationDate;
} JMFNamedEntityAttributes;

extern const struct JMFNamedEntityRelationships {
} JMFNamedEntityRelationships;

extern const struct JMFNamedEntityFetchedProperties {
} JMFNamedEntityFetchedProperties;





@interface JMFNamedEntityID : NSManagedObjectID {}
@end

@interface _JMFNamedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JMFNamedEntityID*)objectID;





@property (nonatomic, strong) NSDate* creationDate;



//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* modificationDate;



//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;






@end

@interface _JMFNamedEntity (CoreDataGeneratedAccessors)

@end

@interface _JMFNamedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;




- (NSString*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSString*)value;




@end
