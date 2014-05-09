/***************************************************************************/
/*                                                                         */
/*  JMFUtility.m                                                           */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               JMFUtility Class implementation File                      */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFUtility.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define APPLICATION_IMAGES_SUBDIRECTORY                     @"/Images"
#define APPLICATION_THUMBNAILS_SUB_DIRECTORY                @"/Thumbnails"
#define CURRENT_IMAGE_NUMBER_KEY                            @"CurrentImageNumber"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFUtility Class Implementation                                        */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFUtility

#pragma mark - Class Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFUtility Class Methods                                               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  applicationDocumentsDirectory                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  imagesDirectory                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)imagesDirectory
{
    return [[JMFUtility applicationDocumentsDirectory] stringByAppendingPathComponent:APPLICATION_IMAGES_SUBDIRECTORY];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  thumbnailsDirectory                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)thumbnailsDirectory
{
    return [[JMFUtility applicationDocumentsDirectory] stringByAppendingPathComponent:APPLICATION_THUMBNAILS_SUB_DIRECTORY];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  createApplicationDirectories                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSError*)createApplicationDirectories
{
    NSString* imagesDirectory = [JMFUtility imagesDirectory];
    NSString* thumbnailsDirectory = [JMFUtility thumbnailsDirectory];
    NSError* error = nil;

    if( ![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        if( error != nil ) return error;
    }
    
    if( ![[NSFileManager defaultManager] fileExistsAtPath:thumbnailsDirectory] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    if( COREDATA_DEBUG && error ) NSLog( @"Error creating App Directories: %@", error );
    return error;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  removeApplicationDirectories                                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSError*)removeApplicationDirectories
{
    NSString* imagesDirectory = [JMFUtility imagesDirectory];
    NSString* thumbnailsDirectory = [JMFUtility thumbnailsDirectory];
    NSError* error = nil;
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory] )
    {
        [[NSFileManager defaultManager] removeItemAtPath:imagesDirectory error:&error];
        if( error != nil ) return error;
    }
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:thumbnailsDirectory] )
    {
        [[NSFileManager defaultManager] removeItemAtPath:thumbnailsDirectory error:&error];
    }
    
    if( COREDATA_DEBUG && error ) NSLog( @"Error deleting App Directories: %@", error );
    return error;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  emptyApplicationDirectories                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSError*)emptyApplicationDirectories
{
    NSError* error = nil;
    if( ( error = [self removeApplicationDirectories] ) == nil )
    {
        error = [self createApplicationDirectories];
    }
    return error;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  generateNewImageFileName                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)generateNewImageFileName
{
    NSUserDefaults* defaultsDictionary = [NSUserDefaults standardUserDefaults];
    long currentImageNumber = [[defaultsDictionary objectForKey:CURRENT_IMAGE_NUMBER_KEY] integerValue];
    NSString* newFileName = [NSString stringWithFormat:@"IMG%05ld.jpg", ++currentImageNumber];
    [defaultsDictionary setObject:[NSNumber numberWithInteger:currentImageNumber] forKey:CURRENT_IMAGE_NUMBER_KEY];
    [defaultsDictionary synchronize];
    return newFileName;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pathForImageFileName:imageFileName:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)pathForImageFileName:(NSString*)imageFileName
{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSString* imageDirectory = [documentsDirectory stringByAppendingPathComponent:APPLICATION_IMAGES_SUBDIRECTORY];
    return [imageDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", imageFileName]];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pathForThumbnailFileName:thumbnailFileName:                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)pathForThumbnailFileName:(NSString*)thumbnailFileName
{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSString* thumbnailsDirectory = [documentsDirectory stringByAppendingPathComponent:APPLICATION_THUMBNAILS_SUB_DIRECTORY];
    return [thumbnailsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", thumbnailFileName]];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pathForFilteredImageFileName:imageFileName:                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)pathForFilteredImageFileName:(NSString*)imageFileName
{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSString* imageDirectory = [documentsDirectory stringByAppendingPathComponent:APPLICATION_IMAGES_SUBDIRECTORY];
    return [NSString stringWithFormat:@"%@/FLT%@", imageDirectory, imageFileName];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pathForFilteredThumbnailFileName:thumbnailFileName:                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)pathForFilteredThumbnailFileName:(NSString*)thumbnailFileName
{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSString* thumbnailsDirectory = [documentsDirectory stringByAppendingPathComponent:APPLICATION_THUMBNAILS_SUB_DIRECTORY];
    return [NSString stringWithFormat:@"%@/FLT%@", thumbnailsDirectory, thumbnailFileName];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  formattedStringFromDate:withFormat:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSString*)formattedStringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:ResString( format )];
    return [dateFormatter stringFromDate:date];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  indexPathForCellSubview:inTableView:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
+ (NSIndexPath*)indexPathForCellSubview:(UIView*)view inTableView:(UITableView*)tableView
{
    while( view != nil )
    {
        if ([view isKindOfClass:[UITableViewCell class]]) return [tableView indexPathForCell:(UITableViewCell*)view];
        else view = [view superview];
    }
    return nil;
}

@end