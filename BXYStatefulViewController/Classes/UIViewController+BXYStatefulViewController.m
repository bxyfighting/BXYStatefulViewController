//
//  UIViewController+BXYStatefulViewController.m
//  Pods
//
//  Created by xiangyu bai on 2017/9/21.
//
//

#import "UIViewController+BXYStatefulViewController.h"
#import <objc/runtime.h>

static void * StatefulViewControllerStateMachineKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation UIViewController (StatefulViewController)

- (BXYViewStateMachine *)bxy_stateMachine {
    BXYViewStateMachine *stateMachine = objc_getAssociatedObject(self, &StatefulViewControllerStateMachineKey);
    if (stateMachine == nil) {
        UIView *view;
        if ([self respondsToSelector:@selector(backingView)]) {
            view = self.backingView;
        } else {
            view = self.view;
        }
        stateMachine = [[BXYViewStateMachine alloc] initWithView:view];
        objc_setAssociatedObject(self, &StatefulViewControllerStateMachineKey, stateMachine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return stateMachine;
}

- (ViewStateMachineState)bxy_currentState {
    return self.bxy_stateMachine.currentState;
}

- (ViewStateMachineState)bxy_lastState {
    return self.bxy_stateMachine.lastState;
}

#pragma mark - views

- (UIView *)bxy_loadingView {
    return [self placeholderView:ViewStateMachineStateLoading];
}

- (void)setBxy_loadingView:(UIView *)bxy_loadingView {
    [self setPlaceholderView:bxy_loadingView forState:ViewStateMachineStateLoading];
}

- (UIView *)bxy_emptyView {
    return [self placeholderView:ViewStateMachineStateEmpty];
}

- (void)setBxy_emptyView:(UIView *)bxy_emptyView {
    [self setPlaceholderView:bxy_emptyView forState:ViewStateMachineStateEmpty];
}

- (UIView *)bxy_errorView {
    return [self placeholderView:ViewStateMachineStateError];
}

- (void)setBxy_errorView:(UIView *)bxy_errorView {
    [self setPlaceholderView:bxy_errorView forState:ViewStateMachineStateError];
}

#pragma mark - transitions

- (void)bxy_setupInitialViewState {
    BOOL isLoading = (self.bxy_lastState == ViewStateMachineStateLoading);
    NSError *error = (self.bxy_lastState == ViewStateMachineStateError) ? [NSError errorWithDomain:@"com.baixiangyu.StatefulViewController.ErrorDomain" code:-1 userInfo:nil] : nil;
    [self bxy_transitionViewStates:isLoading error:error animated:NO completion:nil];
}

- (void)bxy_startLoading:(BOOL)animated completion:(void(^)(void))completion {
    [self bxy_transitionViewStates:YES error:nil animated:animated completion:completion];
}

- (void)bxy_endLoading:(BOOL)animated error:(NSError *)error completion:(void(^)(void))completion {
    [self bxy_transitionViewStates:NO error:error animated:animated completion:completion];
}

- (void)bxy_transitionViewStates:(BOOL)loading
                           error:(NSError *)error
                        animated:(BOOL)animated
                      completion:(void(^)(void))completion {
    NSAssert([self conformsToProtocol:@protocol(StatefulViewControllerProtocol)], @"must implement 'StatefulViewControllerProtocol' protocol.");
    
    // Update view for content (i.e. hide all placeholder views)
    BOOL hasContent = [self respondsToSelector:@selector(hasContent)] ? [self hasContent] : YES;
    if (hasContent) {
        if (error) {
            // show unobstrusive error
            if ([self respondsToSelector:@selector(handleErrorWhenContentAvailable:)]) {
                [self handleErrorWhenContentAvailable:error];
            }
        }
        [self.bxy_stateMachine transitionToState:ViewStateMachineStateNone animated:animated completion:completion];
        return;
    }
    
    // Update view for placeholder
    ViewStateMachineState newState = ViewStateMachineStateEmpty;
    if (loading) {
        newState = ViewStateMachineStateLoading;
    } else if (error) {
        newState = ViewStateMachineStateError;
    }
    [self.bxy_stateMachine transitionToState:newState animated:animated completion:completion];
}

#pragma mark - helper methods

- (UIView *)placeholderView:(ViewStateMachineState)state {
    return [self.bxy_stateMachine viewForState:state];
}

- (void)setPlaceholderView:(UIView *)view forState:(ViewStateMachineState)state {
    [self.bxy_stateMachine addView:view forState:state];
}
#pragma clang diagnostic pop

@end
