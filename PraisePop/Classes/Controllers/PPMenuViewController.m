//
//  PPMenuViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPMenuViewController.h"

#import "PPUser.h"
#import "PPOrganization.h"

#import "PPTimelineViewController.h"
#import "PPMoreViewController.h"

NSString * const kPPTimelineCacheKey = @"PPTimelineViewController";
NSString * const kPPMoreCacheKey = @"PPMoreViewController";

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
    
    // Tagging for buttons for sanity...
    // Feed == 0
    // More == 1
    // etc. when added.
    
    if (button.tag == 0) {
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
