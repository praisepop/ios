//
//  PPMoreViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPMoreViewController.h"

#import "PPMenuViewController.h"

NSString * const kPPMoreCellIdentifier = @"PPMoreCell";

CGFloat const kPPMoreViewControllerSectionHeaderHeight = 50;
CGFloat const kPPMoreViewControllerSectionFooterHeight = 10;

@implementation PPMoreViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
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
    cell.textLabel.font = [UIFont pp_fontWithName:FuturaMedium size:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[self pp_controllerWithIdentifier:@"PPRulesViewController"] animated:YES];
}

- (NSDictionary *)contents {
    return @{
             @"Love Us": @[
                     @"Share PraisePop",
                     @"Like us on Facebook",
                     @"Follow us on Instagram",
                     @"View on the App Store"
                     ],
             @"Help Us": @[
                     @"Provide Feedback"
                     ],
             @"Important Stuff": @[
                     @"Rules",
                     @"Privacy Policy",
                     @"Contact Us"
                     ],
             @"Account Actions": @[
                     @"Logout",
                     @"Change Password"
                     ]
             };
}

@end
