/***************************************************************************/
/*                                                                         */
/*  JMFFilter.m                                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData Filter Entity Class implementation file          */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Generated by mogenerator                                  */
/*                                                                         */
/***************************************************************************/
#import "JMFFilter.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFFilter Class Interface                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFilter ()
{
    CIFilter*  _ciFilter;
}
@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFilter Class implementation                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFFilter

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
    return @[JMFNamedEntityAttributes.name, JMFNamedEntityAttributes.creationDate, JMFFilterRelationships.photo];
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
/*  faceWithName:feature:inContext:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (instancetype)filterWithName:(NSString*)name photo:(JMFPhoto*)photo inContext:(NSManagedObjectContext*)context
{
    JMFFilter* filter = [JMFFilter insertInManagedObjectContext:context];
    
    filter.photo = photo;
    filter.name = name;
    
    return filter;
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
    [self setActive:NO];
    [self setCreationDate:[NSDate date]];
    [self setModificationDate:[NSDate date]];
}
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  ciFilter                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CIFilter*)ciFilter
{
    if( _ciFilter == nil ) _ciFilter = [CIFilter filterWithName:self.name];
    return _ciFilter;
}

#pragma mark - Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  isActive                                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)isActive
{
    return( self.activeValue );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  isValidFilter                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)isValidFilter
{
    BOOL bValid = NO;
    if( self.name != nil && ![self.name isEqualToString:@""] )
    {
        if( ![self.name isEqualToString:@"CIFilterNone"] )
        {
            bValid = YES;
        }
    }
    return bValid;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  isValidCIFilter:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)isValidCIFilter
{
    BOOL bValid = NO;
    if( [[self.ciFilter attributes] objectForKey:kCIInputImageKey] != nil )
    {
        bValid = YES;
    }
    return bValid;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  activeToString                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)activeToString
{
    NSString* localizedString = ( self.activeValue ) ? @"IDS_YES" : @"IDS_NO";
    return NSLocalizedString( localizedString, nil );
}

@end
