#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BXYStatefulPlaceHolderView.h"
#import "BXYStatefulViewController.h"
#import "BXYViewStateMachine.h"
#import "UIViewController+BXYStatefulViewController.h"

FOUNDATION_EXPORT double BXYStatefulViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char BXYStatefulViewControllerVersionString[];

