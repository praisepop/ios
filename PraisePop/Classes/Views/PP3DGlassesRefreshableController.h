//
//  PP3DGlassesRefreshableController.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PP3DGlassesRefreshControlState) {
    PP3DGlassesRefreshControlStateIdle,
    PP3DGlassesRefreshControlStateRefreshing,
    PP3DGlassesRefreshControlStateResetting
};

@class ASBatteryMonitor;

@interface PP3DGlassesRefreshableController : UITableViewController

@end
