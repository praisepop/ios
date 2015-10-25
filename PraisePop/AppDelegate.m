//
//  AppDelegate.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PraisePopAPI.h"

#import "PPMenuViewController.h"
#import "PPTimelineViewController.h"
#import "PPOnboardingViewController.h"

#import <SSKeychain/SSKeychain.h>

#import "AppDelegate.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearances];
    
    self.window = [UIWindow.alloc initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    
    PPMenuViewController *rearViewController = (PPMenuViewController *)[UIStoryboard pp_controllerWithIdentifier:@"PPMenuViewController"];
    
    id frontViewController;
    
    if (PraisePop.currentUser) {
        frontViewController = PPTimelineViewController.new;
        
        frontViewController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    }
    else {
        frontViewController = (UINavigationController *)[UIStoryboard pp_controllerWithIdentifier:@"PPOnboardingNavigationController"];
    }
    
    SWRevealViewController *revealController = [SWRevealViewController.alloc initWithRearViewController:rearViewController frontViewController:frontViewController];
    
    revealController.delegate = self;
    
    self.window.rootViewController = revealController;
    
    [self.window makeKeyAndVisible];
    
    [self APITests];
    
    return YES;
}

- (void)setupAppearances {
    self.window.tintColor = UIColor.whiteColor;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : UIColor.whiteColor,
                                                           NSFontAttributeName : [UIFont pp_fontWithName:FuturaBold size:23]
                                                           }];
    
    [[UINavigationBar appearance] setBarTintColor:UIColor.pp_redColor];
    [[UINavigationBar appearance] setTintColor:UIColor.whiteColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setShadowImage:UIImage.new];
    [[UINavigationBar appearance] setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setTintColor:UIColor.pp_redColor];
    [[UIToolbar appearance] setTranslucent:NO];
    
}

- (void)APITests {
    [[PraisePopAPI sharedClient] login:@"rfawcett@andover.edu" withPassword:@"TEST" success:^(BOOL result) {
        NSLog(@"WE WERE ABLE TO LOGIN!");
        [[PraisePopAPI sharedClient] posts:^(BOOL success, NSArray *posts) {
            NSLog(@"NUMBER OF POSTS: %lu", (unsigned long)posts.count);
        } failure:nil];
    } failure:nil];
}

#pragma mark - SWRevealViewDelegate

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    if (revealController.frontViewController.childViewControllers.count == 0) {
        return;
    }
    
    id controller = revealController.frontViewController.childViewControllers[0];
    
    if (position == FrontViewPositionRight) {
        if ([controller isKindOfClass:UITableViewController.class]) {
            ((UITableViewController *)controller).tableView.userInteractionEnabled = NO;
        }
        else {
            if ([controller isMemberOfClass:UIViewController.class]) {
                ((UIViewController *)controller).view.userInteractionEnabled = NO;
            }
        }
    }
    else {
        if ([controller isKindOfClass:UITableViewController.class]) {
            ((UITableViewController *)controller).tableView.userInteractionEnabled = YES;
        }
        else {
            if ([controller isMemberOfClass:UIViewController.class]) {
                ((UIViewController *)controller).view.userInteractionEnabled = YES;
            }
        }
    }
}

@end
