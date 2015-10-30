//
//  AppDelegate.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>

#import <Parse/Parse.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <SSKeychain/SSKeychain.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Instabug/Instabug.h>

#import "PraisePopAPI.h"

#import "PPMenuViewController.h"
#import "PPTimelineViewController.h"
#import "PPComposeViewController.h"

#import "AppDelegate.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIImageView *splashImageView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow.alloc initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    
    [self setupAppearances];
    
    PraisepopKeys *keys = PraisepopKeys.new;
    
    [Parse setApplicationId:keys.parseAppID clientKey:keys.parseClientKey];
    [Instabug startWithToken:keys.instaBugToken captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
    [Fabric with:@[[Crashlytics class]]];
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
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
    
    self.splashImageView = [UIImageView.alloc initWithFrame:UIScreen.mainScreen.bounds];
    self.splashImageView.y -= 50;
    self.splashImageView.height += 50;
    self.splashImageView.layer.zPosition = 0;
    self.splashImageView.userInteractionEnabled = NO;
    self.splashImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.splashImageView.backgroundColor = UIColor.pp_redColor;

    [self.window.rootViewController.view addSubview:self.splashImageView];
    
    NSMutableArray *images = [@[] mutableCopy];
    
    for (int i = 0; i < 66; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Comp 2_%05d", i]]];
    }
    
    self.splashImageView.animationImages = images;
    self.splashImageView.image = [images lastObject];
    self.splashImageView.animationDuration = 1;
    self.splashImageView.animationRepeatCount = 1;
    
    [self.splashImageView startAnimating];
    
    [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.splashImageView.alpha = 0;
        self.splashImageView.center = CGPointMake(self.splashImageView.center.x, -revealController.view.bounds.size.height);
    } completion:nil];

    double delay = 3 * NSEC_PER_SEC;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay));
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self.splashImageView removeFromSuperview];
    });

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)setupAppearances {
    self.window.tintColor = UIColor.pp_redColor;
    
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
    
    [[UITextView appearance] setTintColor:UIColor.pp_redColor];
    
    [[UITextField appearanceWhenContainedIn:PPComposeViewController.class, nil] setTintColor:UIColor.pp_redColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:UINavigationBar.class, nil] setTintColor:UIColor.whiteColor];
    
    [[UIView appearanceWhenContainedIn:UIAlertController.class, nil] setTintColor:UIColor.pp_redColor];
    
    [Instabug setButtonsColor:[UIColor colorWithRed:0.84 green:0.25 blue:0.11 alpha:1]];
    [Instabug setButtonsFontColor:[UIColor whiteColor]];
    [Instabug setHeaderColor:[UIColor pp_redColor]];
    [Instabug setHeaderFontColor:[UIColor whiteColor]];
    [Instabug setTextBackgroundColor:[UIColor lightGrayColor]];
    [Instabug setTextFontColor:[UIColor whiteColor]];
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
