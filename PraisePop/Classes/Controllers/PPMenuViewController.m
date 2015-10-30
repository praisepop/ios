//
//  PPMenuViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <SWRevealViewController/SWRevealViewController.h>
#import <Instabug/Instabug.h>

#import "PPUser.h"
#import "PPOrganization.h"

#import "PPTimelineViewController.h"
#import "PPMoreViewController.h"

#import "PPMenuViewController.h"

@interface PPMenuViewController ()

@property (strong, nonatomic) IBOutlet UILabel *currentEmail;
@property (strong, nonatomic) IBOutlet UILabel *organizationDomain;

@end

@implementation PPMenuViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentEmail.text = PraisePop.currentUser.email;
    self.organizationDomain.text = [[NSString stringWithFormat:@"@%@", PraisePop.parentOrganization.domain] uppercaseString];
}

- (IBAction)buttonTouch:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == PPMenuButtonTimeline) {
        [self pushFrontViewController:kPPTimelineCacheKey];
    }
    else if (button.tag == PPMenuButtonMore) {
        [self pushFrontViewController:kPPMoreCacheKey];
    }
    else if (button.tag == PPMenuButtonFeedback) {
        [Instabug invokeFeedbackSenderViaEmail];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else {
        UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Reporting Bugs" message:@"To report a bug at any time, simply shake your device when you are having a problem!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)pushFrontViewController:(NSString *)identifier {    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *navigationController = (UINavigationController *)revealController.frontViewController;
    
    if ([[PPMenuControllerCache sharedCache] cache][identifier]) {
        id controller = [[PPMenuControllerCache sharedCache] cache][identifier];
        [navigationController setViewControllers:@[ controller ]];
    }
    else {
        id controller = [[NSClassFromString(identifier) alloc] init];
        [navigationController setViewControllers:@[ controller ]];
    }
    
    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}

@end
