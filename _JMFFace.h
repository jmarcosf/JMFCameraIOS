// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JMFFace.h instead.

#import <CoreData/CoreData.h>
#import "JMFNamedEntity.h"

extern const struct JMFFaceAttributes {
	__unsafe_unretained NSString *faceRect;
	__unsafe_unretained NSString *leftEyePoint;
	__unsafe_unretained NSString *mouthPoint;
	__unsafe_unretained NSString *rightEyePoint;
} JMFFaceAttributes;

extern const struct JMFFaceRelationships {
	__unsafe_unretained NSString *face2photo;
} JMFFaceRelationships;

extern const struct JMFFaceFetchedProperties {
} JMFFaceFetchedProperties;

@class JMFPhoto;






@interface JMFFaceID : NSManagedObjectID {}
@end

@interface _JMFFace : JMFNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JMFFaceID*)objectID;





@property (nonatomic, strong) NSString* faceRect;



//- (BOOL)validateFaceRect:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* leftEyePoint;



//- (BOOL)validateLeftEyePoint:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mouthPoint;



//- (BOOL)validateMouthPoint:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* rightEyePoint;



//- (BOOL)validateRightEyePoint:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JMFPhoto *face2photo;

//- (BOOL)validateFace2photo:(id*)value_ error:(NSError**)error_;





@end

@interface _JMFFace (CoreDataGeneratedAccessors)

@end

@interface _JMFFace (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFaceRect;
- (void)setPrimitiveFaceRect:(NSString*)value;




- (NSString*)primitiveLeftEyePoint;
- (void)setPrimitiveLeftEyePoint:(NSString*)value;




- (NSString*)primitiveMouthPoint;
- (void)setPrimitiveMouthPoint:(NSString*)value;




- (NSString*)primitiveRightEyePoint;
- (void)setPrimitiveRightEyePoint:(NSString*)value;





- (JMFPhoto*)primitiveFace2photo;
- (void)setPrimitiveFace2photo:(JMFPhoto*)value;


@end
