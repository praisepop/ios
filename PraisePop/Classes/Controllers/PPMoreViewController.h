//
//  PPMoreViewController.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SVWebViewController/SVWebViewController.h>

@class PPOnboardingViewController;

@class PPMenuViewController;

typedef NS_ENUM(NSUInteger, PPMenuViewControllerSections) {
    PPMenuViewControllerSectionLoveUs = 0,
    PPMenuViewControllerSectionImportant = 1,
    PPMenuViewControllerSectionActions = 2
};

@interface PPMoreViewController : UITableViewController

@end
