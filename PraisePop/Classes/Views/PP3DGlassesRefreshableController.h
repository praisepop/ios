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

@interface PP3DGlassesRefreshableController : UITableViewController

@end
