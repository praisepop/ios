//
//  PPMenuViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//


#import <SWRevealViewController/SWRevealViewController.h>

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
    else {
        [self pushFrontViewController:kPPMoreCacheKey];
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
