//
//  PPMenuViewController.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPMenuControllerCache.h"

/**
 *  Menu button identifiers.
 */
typedef NS_ENUM(NSUInteger, PPMenuButtonIndexes) {
    /**
     *  The menu button for a timeline controller.
     */
    PPMenuButtonTimeline = 0,
    /**
     *  The menu button for the more controller.
     */
    PPMenuButtonMore = 1,
    /**
     *  The menu button for the more controller.
     */
    PPMenuButtonFeedback = 2,
    /**
     *  The menu button for the bug controller.
     */
    PPMenuButtonReportBug = 3
};

@interface PPMenuViewController : UIViewController

@end
