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

#import "AppDelegate.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearances];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    self.window = [UIWindow.alloc initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    
    PPTimelineViewController *frontViewController = PPTimelineViewController.new;
    PPMenuViewController *rearViewController = (PPMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PPMenuViewController"];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    SWRevealViewController *revealController = [SWRevealViewController.alloc initWithRearViewController:rearViewController frontViewController:frontNavigationController];
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
}

- (void)APITests {
//    [[PraisePopAPI sharedClient] login:@"rfawcett@andover.edu" withPassword:@"TEST" success:^(NSDictionary *result) {
//        NSLog(@"result");
//    } failure:nil];
//    
//    [[PraisePopAPI sharedClient] posts:^(NSArray *posts) {
//        
//    } failure:nil];
}

#pragma mark - SWRevealViewDelegate

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    UITableViewController *controller = (UITableViewController *)revealController.frontViewController.childViewControllers[0];
    
    if (position == FrontViewPositionRight) {
        controller.tableView.userInteractionEnabled = NO;
    }
    else {
        controller.tableView.userInteractionEnabled = YES;
    }
}

@end
