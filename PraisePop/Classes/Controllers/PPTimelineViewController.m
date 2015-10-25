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

#import "PPPostTableViewCell.h"

#import "PPPost.h"

NSString * const kPPPopCellIdentifier = @"PPPostCellIdentifier";
CGFloat const kPPPopCellTextViewRatio = 0.7733f;

@interface PPTimelineViewController () <PPPopDelegate>

@property (strong, nonatomic) NSArray *posts;

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
        self.posts = posts;
        [self.tableView reloadData];
    } failure:nil];
    
    [[PPMenuControllerCache sharedCache] addControllerToCache:self withKey:kPPTimelineCacheKey];
}

#pragma mark - BEGIN PP3DGlassesRefreshableController REQUIRED METHODS
- (void)willBeginRefreshing {
    // TODO: Add stuff that needs to happen before refreshing here...
}

- (void)refresh {
    [[PraisePopAPI sharedClient] posts:^(BOOL success, NSArray *posts) {
        self.posts = posts;
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

- (CGFloat)heightForTextViewAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body = [self.posts[indexPath.row] body];
    
    NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:body attributes:[PPUnselectableTextView attributes]];
    CGFloat width = self.view.width * kPPPopCellTextViewRatio;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    return rect.size.height;
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

- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath {
    if (![self.posts[indexPath.row] upvoted]) {
        [[PraisePopAPI sharedClient] upvote:self.posts[indexPath.row] success:^(BOOL result) {
            PPPostTableViewCell *cell = (PPPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            if (result) {
                [self.posts[indexPath.row] setUpvoted:YES];
                [cell.upvoteButton setImage:[UIImage imageNamed:@"pop-popcorn"] forState:UIControlStateNormal];
            }
            else {
                [self.posts[indexPath.row] setUpvoted:NO];
                [cell.upvoteButton setImage:[UIImage imageNamed:@"pop-kernel"] forState:UIControlStateNormal];
            }
        } failure:nil];
    }
}

- (void)revealComposer:(id)sender {
    PPComposeViewController *composer = (PPComposeViewController *)[PraisePop controllerWithIdentifier:@"PPComposeViewController"];
    
    [self.navigationController presentViewController:composer animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

@end
