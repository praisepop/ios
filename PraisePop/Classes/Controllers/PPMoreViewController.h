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
    PPMenuViewControllerSectionHelpUs = 1,
    PPMenuViewControllerSectionImportant = 2,
    PPMenuViewControllerSectionActions = 3
};

@interface PPMoreViewController : UITableViewController

@end
