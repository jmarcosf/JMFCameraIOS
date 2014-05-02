/***************************************************************************/
/*                                                                         */
/*  UIActionSheet+CompletionBlock.h                                        */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               UIActionSheet Category Class implementation file          */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*         NOTE: Adapted from www.nscookbook.com recipe #22                */
/*                                                                         */
/***************************************************************************/
#import <objc/runtime.h>
#import "UIActionSheet+CompletionBlock.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
static const char kJMFActionWrapper;

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFActionWrapper Class Implementation                                  */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFActionWrapper

#pragma mark - UIActionSheetDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIActionSheetDelegate Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  actionSheet:clickedButtonAtIndex:                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if( self.completionBlock )
    {
        self.completionBlock( actionSheet, buttonIndex) ;
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  actionSheetCancel:                                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    
    if( self.completionBlock )
    {
        self.completionBlock( actionSheet, actionSheet.cancelButtonIndex );
    }
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIActionSheet+CompletionBlock Class Implementation                     */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation UIActionSheet( CompletionBlock )

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
/*  showFromToolbar:withCompletion:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showFromToolbar:(UIToolbar*)toolbar withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ))completion
{
    JMFActionWrapper* actionWrapper = [[JMFActionWrapper alloc] init];
    actionWrapper.completionBlock = completion;
    self.delegate = actionWrapper;
    objc_setAssociatedObject( self, &kJMFActionWrapper, actionWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    [self showFromToolbar:toolbar];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showFromTabBar:withCompletion:                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showFromTabBar:(UITabBar *)tabBar withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ))completion
{
    JMFActionWrapper* actionWrapper = [[JMFActionWrapper alloc] init];
    actionWrapper.completionBlock = completion;
    self.delegate = actionWrapper;
    objc_setAssociatedObject( self, &kJMFActionWrapper, actionWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    [self showFromTabBar:tabBar];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showFromBarButtonItem:animated:withCompletion:                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showFromBarButtonItem:(UIBarButtonItem*)button animated:(BOOL)animated withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ))completion
{
    JMFActionWrapper* actionWrapper = [[JMFActionWrapper alloc] init];
    actionWrapper.completionBlock = completion;
    self.delegate = actionWrapper;
    objc_setAssociatedObject( self, &kJMFActionWrapper, actionWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    [self showFromBarButtonItem:button animated:animated];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showFromRect:inView:animated:withCompletion:                           */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showFromRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ))completion
{
    JMFActionWrapper* actionWrapper = [[JMFActionWrapper alloc] init];
    actionWrapper.completionBlock = completion;
    self.delegate = actionWrapper;
    objc_setAssociatedObject( self, &kJMFActionWrapper, actionWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    [self showFromRect:rect inView:view animated:animated];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  showInView:withCompletion:                                             */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)showInView:(UIView*)view withCompletion:(void(^)( UIActionSheet* actionSheet, NSInteger buttonIndex ))completion
{
    JMFActionWrapper* actionWrapper = [[JMFActionWrapper alloc] init];
    actionWrapper.completionBlock = completion;
    self.delegate = actionWrapper;
    objc_setAssociatedObject( self, &kJMFActionWrapper, actionWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    [self showInView:view];
}

@end
