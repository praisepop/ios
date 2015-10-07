//
//  PPTimelineViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPTimelineViewController.h"

#import "PPMenuControllerCache.h"

#import "PPComposeViewController.h"
#import "PPMenuViewController.h"

#import "PPPopTableViewCell.h"

#import "PPPost.h"

NSString * const kPPPopCellIdentifier = @"PPPopCell";
CGFloat const kPPPopCellTextViewRatio = 0.7733f;

@interface PPTimelineViewController ()

@end

@implementation PPTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pp_setTitle:@"PraisePop"];
    
    [self addReveal];
    [self initiateButtons];
    
    UINib *popCell = [UINib nibWithNibName:@"PPPopCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:popCell forCellReuseIdentifier:kPPPopCellIdentifier];
    
    [[PPMenuControllerCache sharedCache] addControllerToCache:self withKey:kPPTimelineCacheKey];
}

- (void)willBeginRefreshing {
}

- (void)refresh {
}

- (void)initiateButtons {
    UIBarButtonItem *composeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose-nav-button"]
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(revealComposer:)];
    
    self.navigationItem.rightBarButtonItem = composeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self heightForTextViewAtIndexPath:indexPath] <= 35) {
        return 130;
    }
    else {
        return [self heightForTextViewAtIndexPath:indexPath] + 100;
    }
}

- (CGFloat)heightForTextViewAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body = @"Your voice gave me chills!!";
    
    NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:body attributes:[PPUnselectableTextView attributes]];
    CGFloat width = self.view.width * kPPPopCellTextViewRatio;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPPopTableViewCell *cell = (PPPopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPPPopCellIdentifier];
    
    
    PPPost *post = PPPost.new;
    post.body = @"Your voice gave me chills!!";
    
    cell.post = post;
    
    return cell;
}

- (void)revealComposer:(id)sender {
    PPComposeViewController *composer = (PPComposeViewController *)[PraisePop controllerWithIdentifier:@"PPComposeViewController"];
    
    [self.navigationController presentViewController:composer animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

@end
