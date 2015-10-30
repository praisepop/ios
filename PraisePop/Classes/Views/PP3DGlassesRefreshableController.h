//
//  PP3DGlassesRefreshableController.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The status of the controller refresh view.
 */
typedef NS_ENUM(NSUInteger, PP3DGlassesRefreshControlState) {
    /**
     *  An idle state for the controller.
     */
    PP3DGlassesRefreshControlStateIdle,
    /**
     *  The refreshing state for the controller.
     */
    PP3DGlassesRefreshControlStateRefreshing,
    /**
     *  The resetting state for the controller.
     */
    PP3DGlassesRefreshControlStateResetting
};

@class PP3DGlassesRefreshableController;

@protocol PP3DGlassesRefreshDelegate <NSObject>

@optional;

/**
 *  Called before the refreshing animation starts.
 */
- (void)willBeginRefreshing;

/**
 *  Tells the delegate if the control has changes state.
 *
 *  @param state The new state of the control.
 */
- (void)didChangeState:(PP3DGlassesRefreshControlState)state;

@required;

/**
 *  Allows you to use your own functionality while loading data.
 */
- (void)didBeginRefreshing;

@end

@interface PP3DGlassesRefreshableController : UITableViewController

/**
 *  Our refresh delegate.
 */
@property (weak, nonatomic) id<PP3DGlassesRefreshDelegate> refreshDelegate;

/**
 *  Allows you to call the refresh method from a subclass (without scrolling).
 */
- (void)refresh;

@end
