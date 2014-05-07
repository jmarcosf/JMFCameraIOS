/***************************************************************************/
/*                                                                         */
/*  JMFFilterProperty.m                                                    */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData Filter Property Entity Class implementation file */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Generated by mogenerator                                  */
/*                                                                         */
/***************************************************************************/
#import "JMFFilterProperty.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFFilterProperty Class Interface                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFilterProperty ()
{
}
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFilterProperty Class implementation                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFilterProperty

#pragma mark - Key Value Observing Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Key Value Observing Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  observableKeys                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSArray*)observableKeys
{
    return @[JMFNamedEntityAttributes.name, JMFNamedEntityAttributes.creationDate, JMFFilterPropertyRelationships.filter];
}

#pragma mark - Initialization Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  propertyWithName:filter:inContext:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (instancetype)propertyWithName:(NSString*)name filter:(JMFFilter*)filter inContext:(NSManagedObjectContext*)context;
{
    JMFFilterProperty* filterProperty = [JMFFilterProperty insertInManagedObjectContext:context];
    
    filterProperty.filter = filter;
    filterProperty.name = name;
    
    return filterProperty;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  awakeFromInsert                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void) awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreationDate:[NSDate date]];
    [self setModificationDate:[NSDate date]];
    self.value = [NSNumber numberWithFloat:0.0f];
}

@end