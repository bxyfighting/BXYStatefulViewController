//
//  BXYViewStateMachine.h
//  BXYStatefulViewController
//
//  Created by baixiangyu on 2017/9/20.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ViewStateMachineState) {
    ViewStateMachineStateNone,
    ViewStateMachineStateLoading,
    ViewStateMachineStateEmpty,
    ViewStateMachineStateError,
};

/**
 *  A state machine that manages a set of views.
 *  There are two possible states:
 *        * Show a specific placeholder view, represented by a key
 *        * Hide all managed views
 */

@interface BXYViewStateMachine : NSObject

/*
 *  The view that should act as the superview for any added views
 */
@property (nonatomic, strong, readonly) UIView *view;

/**
 *  An invisible container view that gets added to the view.
 *  The placeholder views will be added to the containerView.
 *
 *  view
 *    \_ containerView
 *             \_ error | loading | empty view
 */
@property (nonatomic, strong, readonly) UIView *containerView;

/**
 *  The current display state of views
 */
@property (nonatomic, assign, readonly) ViewStateMachineState currentState;

/**
 *  The last state that was enqueued
 */
@property (nonatomic, assign, readonly) ViewStateMachineState lastState;

/**
 *  - parameter view:     The view that should act as the superview for any added views
 *  - returns:            A view state machine
 */
- (instancetype)initWithView:(UIView *)view;

/**
 *  - returns: the view for a given state
 */
- (UIView *)viewForState:(ViewStateMachineState)state;

/**
 *  Associates a view for the given state
 */
- (void)addView:(UIView *)view forState:(ViewStateMachineState)state;

/**
 *  Removes the view for the given state
 */
- (void)removeViewForState:(ViewStateMachineState)state;

/**
 *  Adds and removes views to and from the `view` based on the given state.
 *  Animations are synchronized in order to make sure that there aren't any animation gliches in the UI
 *
 *  - parameter state:        The state to transition to
 *  - parameter animated:     true if the transition should fade views in and out
 *  - parameter completion:   called when all animations are finished and the view has been updated
 */
- (void)transitionToState:(ViewStateMachineState)state
                 animated:(BOOL)animated
               completion:(void(^)(void))completion;

@end
