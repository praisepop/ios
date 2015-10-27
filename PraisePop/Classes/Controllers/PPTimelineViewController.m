//
//  PPTimelineViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>

#import "PPPost.h"
#import "PPMenuControllerCache.h"

#import "PPPostTableViewCell.h"
#import "PPUnselectableTextView.h"

#import "PPComposeViewController.h"
#import "PPMenuViewController.h"

#import "PPTimelineViewController.h"

NSString * const kPPPopCellIdentifier = @"PPPostCellIdentifier";
CGFloat const kPPPopCellTextViewRatio = 0.7733f;

@interface PPTimelineViewController () <PPPostDelegate, PPComposerDelegate>

@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation PPTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pp_setTitle:@"PraisePop"];
    
    [self addReveal];
    [self initiateButtons];
    
    UINib *popCell = [UINib nibWithNibName:@"PPPostCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:popCell forCellReuseIdentifier:kPPPopCellIdentifier];
    
    [[PraisePopAPI sharedClient] posts:^(BOOL success, NSArray *posts) {
        self.posts = posts.mutableCopy;
        [self.tableView reloadData];
    } failure:nil];
    
    [[PPMenuControllerCache sharedCache] addControllerToCache:self withKey:kPPTimelineCacheKey];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

#pragma mark - BEGIN PP3DGlassesRefreshableController REQUIRED METHODS

- (void)willBeginRefreshing {
    // TODO: Add stuff that needs to happen before refreshing here...
}

- (void)refresh {
    [[PraisePopAPI sharedClient] posts:^(BOOL success, NSArray *posts) {
        self.posts = posts.mutableCopy;
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark - END REQUIRED METHODS

- (void)initiateButtons {
    UIBarButtonItem *composeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose-nav-button"]
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(revealComposer:)];
    
    self.navigationItem.rightBarButtonItem = composeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self heightForTextViewAtIndexPath:indexPath] <= 35) {
        return 130;
    }
    else {
        return [self heightForTextViewAtIndexPath:indexPath] + 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PPPostTableViewCell *postCell = (PPPostTableViewCell *)cell;
    
    if ([self.posts[indexPath.row] upvoted]) {
        [postCell.upvoteButton setImage:[UIImage imageNamed:@"pop-popcorn"] forState:UIControlStateNormal];
    }
    else {
        [postCell.upvoteButton setImage:[UIImage imageNamed:@"pop-kernel"] forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPPostTableViewCell *cell = (PPPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPPPopCellIdentifier];
    if (cell == nil) {
        cell = [[PPPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPPPopCellIdentifier];
    }
    
    cell.post = self.posts[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark - PPPostDelegate

- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath {
    if (![self.posts[indexPath.row] upvoted]) {
        PPPostTableViewCell *cell = (PPPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [[PraisePopAPI sharedClient] upvote:self.posts[indexPath.row] success:^(BOOL result) {
            
            if (result) {
                [self.posts[indexPath.row] setUpvoted:YES];
                [cell.upvoteButton setImage:[UIImage imageNamed:@"pop-popcorn"] forState:UIControlStateNormal];
            }
            else {
                [self.posts[indexPath.row] setUpvoted:NO];
                [cell.upvoteButton setImage:[UIImage imageNamed:@"pop-kernel"] forState:UIControlStateNormal];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cell unvote];
            [self.posts[indexPath.row] setUpvoted:NO];
            [error pp_showError];
        }];
    }
}

- (void)didTapMore:(NSIndexPath *)indexPath {
    if ([self.posts[indexPath.row] isDeletable]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Delete"
                                               otherButtonTitles:@"Report", nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                [[PraisePopAPI sharedClient] delete:self.posts[indexPath.row] success:^(BOOL result) {
                    if (result) {
                        [self.posts removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                    }
                    else {
                        [NSError pp_showErrorAlertWithMessage:@"We were unable to delete your post.  Please check your connection and try again"];
                    }
                } failure:nil];
            }
            else if (buttonIndex == 1) {
                [[PraisePopAPI sharedClient] flag:self.posts[indexPath.row] success:^(BOOL result) {
                    if (result) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"By reporting this post, you have made PraisePop a safer place." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alert show];
                    }
                    else {
                        [NSError pp_showErrorAlertWithMessage:@"We were unable to report this post.  Please check your connection and try again."];
                    }
                } failure:nil];
            }
        };
        
        [as showInView:self.view];
    }
    else {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Option"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                          destructiveButtonTitle:@""
                                               otherButtonTitles:@"Report", nil];
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                [[PraisePopAPI sharedClient] flag:self.posts[indexPath.row] success:^(BOOL result) {
                    if (result) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"By reporting this post, you have made PraisePop a safer place." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alert show];
                    }
                    else {
                        [NSError pp_showErrorAlertWithMessage:@"We were unable to report this post.  Please check your connection and try again."];
                    }
                } failure:nil];
            }
        };
        
        [as showInView:self.view];
    }
}

#pragma mark - PPComposerDelegate

- (void)didPost {
    [self refresh];
}


- (void)revealComposer:(id)sender {
    PPComposeViewController *composer = (PPComposeViewController *)[UIStoryboard pp_controllerWithIdentifier:@"PPComposeViewController"];
    composer.delegate = self;
    
    [self.navigationController presentViewController:composer animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

#pragma mark - Helpers

- (CGFloat)heightForTextViewAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body = [self.posts[indexPath.row] body];
    
    NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:body attributes:[PPUnselectableTextView attributes]];
    CGFloat width = self.view.width * kPPPopCellTextViewRatio;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    return rect.size.height;
}

@end
