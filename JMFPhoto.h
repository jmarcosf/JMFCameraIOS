/***************************************************************************/
/*                                                                         */
/*  JMFPhoto.h                                                             */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               CoreData Photo Entity Class definition file               */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Generated by mogenerator                                  */
/*                                                                         */
/***************************************************************************/
#import "_JMFPhoto.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Enums                                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
typedef NS_ENUM( NSInteger, JMFPhotoSource )
{
    JMFPhotoSourceUnknown    =  0,
    JMFPhotoSourceCamera     =  1,
    JMFPhotoSourceFlickr     =  2,
    JMFPhotoSourceFacebook   =  3,
    JMFPhotoSourceInstagram  =  4,
    JMFPhotoSourceTwitter    =  5,
    JMFPhotoSourceOther      =  6
};

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFPhoto Class Interface                                               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFPhoto : _JMFPhoto

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (instancetype)photoWithImage:(UIImage*)image source:(JMFPhotoSource)source thumbnail:(UIImage*)thumbnail inContext:(NSManagedObjectContext*)context;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Instance Methods                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)setLocationLongitude:(NSNumber*)longitude latitude:(NSNumber*)latitude altitude:(NSNumber*)altitude geoLocation:(NSString*)geoLocation;
- (NSString*)sourceToString;
- (NSString*)orientationToString;

@end

