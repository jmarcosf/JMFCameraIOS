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
+ (BOOL)createApplicationDirectories
{
    NSString* imagesDirectory = [JMFUtility imagesDirectory];
    NSString* thumbnailsDirectory = [JMFUtility thumbnailsDirectory];
    NSError* imageDirectoryError = nil;
    NSError* thumbnailsDirectoryError = nil;

    if( ![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:NO attributes:nil error:&imageDirectoryError];
    }
    
    if( ![[NSFileManager defaultManager] fileExistsAtPath:thumbnailsDirectory] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailsDirectory withIntermediateDirectories:NO attributes:nil error:&thumbnailsDirectoryError];
    }
    
    return ( !imageDirectoryError && !thumbnailsDirectoryError );
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
    int currentImageNumber = [[defaultsDictionary objectForKey:CURRENT_IMAGE_NUMBER_KEY] integerValue];
    NSString* newFileName = [NSString stringWithFormat:@"IMG%05d.jpg", ++currentImageNumber];
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

@end