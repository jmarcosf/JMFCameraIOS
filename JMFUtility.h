/***************************************************************************/
/*                                                                         */
/*  JMFUtility.h                                                           */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               JMFUtility Class definition file                          */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFUtility Class Interface                                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFUtility : NSObject

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Methods                                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSError*)createApplicationDirectories;
+ (NSError*)removeApplicationDirectories;
+ (NSError*)emptyApplicationDirectories;
+ (NSString*)generateNewImageFileName;
+ (NSString*)pathForImageFileName:(NSString*)imageFileName;
+ (NSString*)pathForThumbnailFileName:(NSString*)thumbnailFileName;
+ (NSString*)pathForFilteredImageFileName:(NSString*)imageFileName;
+ (NSString*)pathForFilteredThumbnailFileName:(NSString*)thumbnailFileName;
+ (NSString*)formattedStringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSIndexPath*)indexPathForCellSubview:(UIView*)view inTableView:(UITableView*)tableView;
+ (NSString*)generateUuidString;
+ (NSError*)deleteFileAtPath:(NSString*)filePath;
@end


