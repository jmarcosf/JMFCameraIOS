/***************************************************************************/
/*                                                                         */
/*  JMFFilter.h                                                            */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData Filter Entity Class definition file              */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Generated by mogenerator                                  */
/*                                                                         */
/***************************************************************************/
#import "_JMFFilter.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_FILTER_NONE                             @"CIFilterNone"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFilter Class Interface                                              */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFilter : _JMFFilter

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (instancetype)filterWithName:(NSString*)name photo:(JMFPhoto*)photo inContext:(NSManagedObjectContext*)context;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (BOOL)isActive;
- (BOOL)isValidFilter;
- (BOOL)isValidCIFilter:(CIFilter*)filter;
- (NSString*)activeToString;

@end
