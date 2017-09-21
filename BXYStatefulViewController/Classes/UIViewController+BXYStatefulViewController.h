//
//  UIViewController+BXYStatefulViewController.h
//  Pods
//
//  Created by xiangyu bai on 2017/9/21.
//
//

#import <UIKit/UIKit.h>
#import "BXYViewStateMachine.h"

@protocol BackingViewProvider <NSObject>

/**
 *  The backing view, usually a UIViewController's view.
 *  All placeholder views will be added to this view instance.
 */
- (UIView *)backingView;

@end


@protocol StatefulViewControllerProtocol <NSObject>
@required

/**
 *  Return true if content is available in your controller.
 *
 *  - returns: true if there is content available in your controller.
 */
- (BOOL)hasContent;

/**
 *  This method is called if an error occurred, but `hasContent` returned true.
 *  You would typically display an unobstrusive error message that is easily dismissable
 *  for the user to continue browsing content.
 *
 *  - parameter error:    The error that occurred
 */
- (void)handleErrorWhenContentAvailable:(NSError *)error;

@end

/**
 *  StatefulViewController category may be adopted by a view controller
 *  in order to transition to error, loading or empty views.
 */
@interface UIViewController (StatefulViewController) <StatefulViewControllerProtocol, BackingViewProvider>

/**
 *  The view state machine backing all state transitions
 */
@property (nonatomic, strong, readonly) BXYViewStateMachine *bxy_stateMachine;

/**
 *  The current transition state of the view controller.
 *  All states other than `NONE` imply that there is a placeholder view shown.
 */
@property (nonatomic, assign, readonly) ViewStateMachineState bxy_currentState;

/**
 *  The last transition state that was sent to the state machine for execution.
 *  This does not imply that the state is currently shown on screen. Transitions are queued up and
 *  executed in sequential order.
 */
@property (nonatomic, assign, readonly) ViewStateMachineState bxy_lastState;

/**
 *  The loading view is shown when the `startLoading` method gets called
 */
@property (nonatomic, strong) UIView *bxy_loadingView;

/**
 *  The empty view is shown when the `hasContent` method returns false
 */
@property (nonatomic, strong) UIView *bxy_emptyView;

/**
 *  The error view is shown when the `endLoading` method returns an error
 */
@property (nonatomic, strong) UIView *bxy_errorView;


/**
 *  Sets up the initial state of the view.
 *  This method should be called as soon as possible in a view controller's
 *  life cycle, e.g. `viewWillAppear:`, to transition to the appropriate state.
 */
- (void)bxy_setupInitialViewState;

/**
 *  Transitions the controller to the loading state and shows
 *  the loading view if there is no content shown already.
 *
 *  - parameter animated:     true if the switch to the placeholder view should be animated, false otherwise
 */
- (void)bxy_startLoading:(BOOL)animated completion:(void(^)(void))completion;

/**
 *  Ends the controller's loading state.
 *  If an error occurred, the error view is shown.
 *  If the `hasContent` method returns false after calling this method, the empty view is shown.
 *
 *  - parameter animated: 	true if the switch to the placeholder view should be animated, false otherwise
 *  - parameter error:		An error that might have occurred whilst loading
 */
- (void)bxy_endLoading:(BOOL)animated error:(NSError *)error completion:(void(^)(void))completion;

/**
 *  Transitions the view to the appropriate state based on the `loading` and `error`
 *  input parameters and shows/hides corresponding placeholder views.
 *
 *  - parameter loading:		true if the controller is currently loading
 *  - parameter error:		An error that might have occurred whilst loading
 *  - parameter animated:	true if the switch to the placeholder view should be animated, false otherwise
 */
- (void)bxy_transitionViewStates:(BOOL)loading
                           error:(NSError *)error
                        animated:(BOOL)animated
                      completion:(void(^)(void))completion;

@end
