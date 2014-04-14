/***************************************************************************/
/*                                                                         */
/*  UIAlertView+CompletionBlock.h                                          */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIAlertView Category Class implementation file            */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Adapted from www.nscookbook.com recipe #22                */
/*                                                                         */
/***************************************************************************/
#import <objc/runtime.h>
#import "UIAlertView+CompletionBlock.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static const char kNSCBAlertWrapper;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  NSCBAlertWrapper Class Implemantation                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation NSCBAlertWrapper

#pragma mark - UIAlertViewDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIAlertViewDelegate Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  alertView:clickedButtonAtIndex:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( self.completionBlock )
    {
        self.completionBlock(alertView, buttonIndex);
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  alertViewCancel:                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)alertViewCancel:(UIAlertView *)alertView
{

    if( self.completionBlock )
    {
        self.completionBlock(alertView, alertView.cancelButtonIndex);
    }
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIAlertView+CompletionBlock Class Implemantation                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation UIAlertView (CompletionBlock)

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showWithCompletion:                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion
{
    NSCBAlertWrapper *alertWrapper = [[NSCBAlertWrapper alloc] init];
    alertWrapper.completionBlock = completion;
    self.delegate = alertWrapper;
    objc_setAssociatedObject(self, &kNSCBAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self show];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showWithActivityIndicator                                              */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showWithActivityIndicatorWithColor:(UIColor*)color
{
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake( 0, 0, 36, 36 );
    activityIndicator.color = color;
    [activityIndicator startAnimating];
    [self setValue:activityIndicator forKey:@"accessoryView"];
    [self show];
}

@end

