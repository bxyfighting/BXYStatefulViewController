//
//  BXYViewStateMachine.m
//  BXYStatefulViewController
//
//  Created by baixiangyu on 2017/9/20.
//

#import "BXYViewStateMachine.h"
#import "BXYStatefulPlaceHolderView.h"

@interface BXYViewStateMachine ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIView *> *viewStore;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, assign, readwrite) ViewStateMachineState currentState;
@property (nonatomic, assign, readwrite) ViewStateMachineState lastState;

@end

@implementation BXYViewStateMachine

#pragma mark - init

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _viewStore = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.baixiangyu.viewStateMachine.queue", DISPATCH_QUEUE_SERIAL);
        _view = view;
        
        _currentState = ViewStateMachineStateNone;
        _lastState = ViewStateMachineStateNone;
    }
    return self;
}

#pragma mark - add and remove view states

- (UIView *)viewForState:(ViewStateMachineState)state {
    return _viewStore[@(state)];
}

- (void)addView:(UIView *)view forState:(ViewStateMachineState)state {
    _viewStore[@(state)] = view;
}

- (void)removeViewForState:(ViewStateMachineState)state {
    _viewStore[@(state)] = nil;
}

#pragma mark - Switch view state

- (void)transitionToState:(ViewStateMachineState)state
                 animated:(BOOL)animated
               completion:(void(^)(void))completion {
    _lastState = state;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        if (state == strongSelf.currentState) {
            return;
        }
        
        // Suspend the queue, it will be resumed in the completion block
        dispatch_suspend(strongSelf.queue);
        strongSelf.currentState = state;
        
        void(^c)(void) = ^{
            dispatch_resume(strongSelf.queue);
            if (completion) {
                completion();
            }
        };
        
        // Switch state and update the view
        dispatch_async(dispatch_get_main_queue(), ^{
            if (state == ViewStateMachineStateNone) {
                [strongSelf hideAllViews:animated completion:c];
            } else {
                [strongSelf showViewForState:state animated:animated completion:c];
            }
        });
    });
}

#pragma mark - private methods

- (void)showViewForState:(ViewStateMachineState)state
                animated:(BOOL)animated
              completion:(void(^)(void))completion {
    // Add the container view
    self.containerView.frame = self.view.bounds;
    [self.view addSubview:self.containerView];
    
    NSMutableDictionary *store = self.viewStore;
    UIView *newView = store[@(state)];
    if (newView) {
        newView.alpha = animated ? 0.0 : 1.0;
        
        UIEdgeInsets insets;
        if ([newView respondsToSelector:@selector(placeholderViewInsets)]) {
            insets = [(id<BXYStatefulPlaceHolderView>)newView placeholderViewInsets];
        } else {
            insets = UIEdgeInsetsZero;
        }
        CGRect result = UIEdgeInsetsInsetRect(self.containerView.bounds, insets);
        newView.frame = result;
        
        [self.containerView addSubview:newView];
    }
    
    void(^animations)(void) = ^{
        if (newView == store[@(state)]) {
            newView.alpha = 1.0;
        }
    };
    
    void(^animationCompletion)(BOOL) = ^(BOOL finished){
        [store enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIView *view, BOOL * _Nonnull stop) {
            if (key.integerValue != state) {
                [view removeFromSuperview];
            }
        }];
        
        if (completion) {
            completion();
        }
    };
    
    [self animateChanges:animated animations:animations completion:animationCompletion];

}

- (void)hideAllViews:(BOOL)animated completion:(void(^)(void))completion {
    NSMutableDictionary *store = self.viewStore;
    
    void(^animations)(void) = ^{
        [store enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView *view, BOOL * _Nonnull stop) {
            view.alpha = 0.0;
        }];
    };
    
    void(^animationCompletion)(BOOL) = ^(BOOL finished){
        [store enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView *view, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
        
        // Remove the container view
        [self.containerView removeFromSuperview];
        
        if (completion) {
            completion();
        }
    };
    
    [self animateChanges:animated animations:animations completion:animationCompletion];
}

- (void)animateChanges:(BOOL)animated animations:(void(^)(void))animations completion:(void(^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:animations completion:completion];
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

#pragma mark - containerView

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

@end
