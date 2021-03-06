//
//  PPMoreViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>

#import "PPMenuViewController.h"

#import "PPMoreViewController.h"

NSString * const kPPMoreCellIdentifier = @"PPMoreCell";

CGFloat const kPPMoreViewControllerSectionHeaderHeight = 50;
CGFloat const kPPMoreViewControllerSectionFooterHeight = 10;

@implementation PPMoreViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pp_setTitle:@"More"];
    
    [self addReveal];
    
    self.tableView.backgroundColor = UIColor.pp_offWhiteColor;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kPPMoreCellIdentifier];
    [[PPMenuControllerCache sharedCache] addControllerToCache:self withKey:kPPMoreCacheKey];
    
    self.tableView.tableFooterView = self.footerView;
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset.bottom -= self.tableView.tableFooterView.frame.size.height;
    self.tableView.contentInset = inset;
}

- (UIView *)footerView {
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.contents.allKeys[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kPPMoreViewControllerSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kPPMoreViewControllerSectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = UIColor.pp_redColor;
    header.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    header.textLabel.font = [UIFont pp_fontWithName:FuturaMedium size:18];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contents.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents[self.contents.allKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPPMoreCellIdentifier];
    
    NSString *key = self.contents.allKeys[indexPath.section];
    
    cell.textLabel.text = self.contents[key][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PPMenuViewControllerSectionLoveUs) {
        if (indexPath.row == 0) {
            NSString *shareText = @"Post anonymous shoutouts to anyone in your community with PraisePop. What's poppin? http://praisepop.us/";
            NSArray *share = @[shareText];
            
            UIActivityViewController *activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:share
                                              applicationActivities:nil];
            
            activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToFlickr, UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll];
            
            [self.navigationController presentViewController:activityViewController
                                               animated:YES
                                                  completion:^{
                                                      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                                                  }];
        }
        else if (indexPath.row == 1) {
            // @"fb://profile/397273957141400" should work, but since we changed the facebook name, I think it's
            // throwing it off.
            [self openURL:@"https://www.facebook.com/trypraisepop" actual:@"https://www.facebook.com/trypraisepop"];
        }
        else if (indexPath.row == 2) {
            [self openURL:@"twitter://user?screen_name=trypraisepop" actual:@"https://twitter.com/trypraisepop"];
        }
        else {
            [self openURL:@"http://itunes.apple.com/app/1053365584" actual:@"http://itunes.apple.com/app/1053365584"];
        }
    }
    else if (indexPath.section == PPMenuViewControllerSectionImportant) {
        if (indexPath.row == 0) {
            UIViewController *rulesViewcontroller = (UIViewController *)[UIStoryboard pp_controllerWithIdentifier:@"PPRulesViewController"];
            [rulesViewcontroller pp_setTitle:@"Rules"];
            [self.navigationController pushViewController:rulesViewcontroller animated:YES];
        }
        else if (indexPath.row == 1) {
            [self openURL:nil actual:@"http://praisepop.tumblr.com/privacy-policy"];
        }
        else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-Acknowledgements" ofType:@"plist"];
            VTAcknowledgementsViewController *viewController = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
            [viewController pp_setTitle:@"Licenses"];
            viewController.headerText = NSLocalizedString(@"We love open source software.", nil); // optional
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else {
        if (indexPath.row == 0) {
            [PraisePop destorySession];
            [[PPMenuControllerCache sharedCache] removeControllerFromCache:kPPTimelineCacheKey];
            self.revealViewController.frontViewController = (UINavigationController *)[UIStoryboard pp_controllerWithIdentifier:@"PPOnboardingNavigationController"];
            self.revealViewController.frontViewController.childViewControllers[0].view.userInteractionEnabled = YES;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openURL:(NSString *)try actual:(NSString *)actual {
    NSURL *URL = [NSURL URLWithString:actual];
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:try]]) {
        [UIApplication.sharedApplication openURL:URL];
    }
    else {
        SVWebViewController *webViewController = [SVWebViewController.alloc initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (NSDictionary *)contents {
    return @{
             @"Love Us": @[
                     @"Share PraisePop",
                     @"Like us on Facebook",
                     @"Follow us on Twitter",
                     @"View on the App Store"
                     ],
             @"Important Stuff": @[
                     @"Rules",
                     @"Privacy Policy",
                     @"Third Party Licenses"
                     ],
             @"Account Actions": @[
                     @"Logout",
                     // @"Change Password"
                     ]
             };
}

@end
