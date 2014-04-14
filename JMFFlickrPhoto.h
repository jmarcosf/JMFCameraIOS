/***************************************************************************/
/*                                                                         */
/*  JMFFlickrPhoto.h                                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Flickr Photo Class definition file                        */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Modified from Brandon Trebitowski file                    */
/*                                                                         */
/***************************************************************************/
#import <Foundation/Foundation.h>

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrPhoto Class Interface                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFFlickrPhoto : NSObject

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Properties                                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@property (nonatomic,strong) UIImage*       thumbnail;
@property (nonatomic,strong) UIImage*       largeImage;

@property (nonatomic)        long long      photoID;
@property (nonatomic)        NSInteger      farm;
@property (nonatomic)        NSInteger      server;
@property (nonatomic,strong) NSString*      secret;

@end

