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

NSString * const kPPPostCellIdentifier = @"PPPostCellIdentifier";
NSString * const kPPLoadingCellIdentifier = @"PPLoadingCellIdentifier";

CGFloat const kPPPopCellTextViewRatio = 0.7733f;

@interface PPTimelineViewController () <PPPostDelegate, PPComposerDelegate, PP3DGlassesRefreshDelegate>

/**
 *  A mutable array of post objects.
 */
@property (strong, nonatomic) NSMutableArray *posts;

/**
 *  A timer used to check reachability status.
 */
@property (strong, nonatomic) NSTimer *timer;

/**
 *  The current page for pagination.
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  The total pages for pagination.
 */
@property (nonatomic, assign) NSInteger totalPages;
/**
 *  The total items for pagination.
 */
@property (nonatomic, assign) NSInteger totalItems;
/**
 *  The maximum number of pages for pagination.
 */
@property (nonatomic, assign) NSInteger maxPages;

/**
 *  Whether or not the activity indicator should show.
 */
@property (nonatomic, assign) BOOL showsPaging;

/**
 *  The current state of the refresh control.
 */
@property (nonatomic) PP3DGlassesRefreshControlState state;

@end

@implementation PPTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pp_setTitle:@"PraisePop"];
    
    [self addReveal];
    [self initiateButtons];
    
    UINib *postCell = [UINib nibWithNibName:@"PPPostCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:postCell forCellReuseIdentifier:kPPPostCellIdentifier];
    
    UINib *loadingCell = [UINib nibWithNibName:@"PPLoadingCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:loadingCell forCellReuseIdentifier:kPPLoadingCellIdentifier];
    
    self.posts = [@[] mutableCopy];
    self.currentPage = 0;
    self.totalPages  = 0;
    self.totalItems  = 0;
    self.showsPaging = false;
    
    [[PPMenuControllerCache sharedCache] addControllerToCache:self withKey:kPPTimelineCacheKey];
    
    super.refreshDelegate = self;
    [super refresh];
    
    [self checkNetwork];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(checkNetwork) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkNetwork];
}

- (void)checkNetwork {
    BOOL reachable = PraisePopAPI.isReachable;
    [PraisePopAPI showActivityIndicator];
    
    [self toggleReachability:reachable];
    
    /**
     *  For now leave this out because we don't want to displace the feed that often.
     *
     *  if (reachable) {
     *      [self refresh];
     *  }
     */
    
    [PraisePopAPI hideActivityIndicator];
}

- (void)toggleReachability:(BOOL)reachable {
    self.navigationItem.leftBarButtonItem.enabled = reachable;
    self.navigationItem.rightBarButtonItem.enabled = reachable;
    
    self.revealViewController.panGestureRecognizer.enabled = reachable;
}

#pragma mark - PP3dGlassesRefreshController

- (void)didChangeState:(PP3DGlassesRefreshControlState)state {
    self.state = state;
}

- (void)willBeginRefreshing {
    [self.tableView reloadData];
}

/**
 *  Resets the entire posts array.
 */
- (void)didBeginRefreshing {
    [[PraisePopAPI sharedClient] posts:1 success:^(BOOL result, NSArray *posts, NSUInteger currentPage, NSUInteger totalPages, NSUInteger totalItems) {
        self.posts = posts.mutableCopy;
        [self toggleReachability:result];
        
        self.currentPage = currentPage;
        self.totalPages  = totalPages;
        self.totalItems  = totalItems;
        self.showsPaging = currentPage != totalPages;
        
        [self.tableView reloadData];
    } failure:nil];
}

- (void)loadPosts:(NSUInteger)page {
    [[PraisePopAPI sharedClient] posts:page success:^(BOOL result, NSArray *posts, NSUInteger currentPage, NSUInteger totalPages, NSUInteger totalItems) {
        [self toggleReachability:result];
        [self.posts addObjectsFromArray:posts];
        
        self.currentPage = currentPage;
        self.totalPages  = totalPages;
        self.totalItems  = totalItems;
        self.showsPaging = currentPage != totalPages;
        [self.tableView reloadData];
    } failure:nil];
}

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
    NSUInteger count = self.showsPaging ? self.posts.count + 1 : self.posts.count;
    
    return self.posts.count == 0 ? 1 : count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showsPaging && indexPath.row == self.posts.count) {
        return UITableViewAutomaticDimension;
    }
    
    if ([self heightForTextViewAtIndexPath:indexPath] <= 35) {
        return 130;
    }
    else {
        return [self heightForTextViewAtIndexPath:indexPath] + 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.posts.count != 0) {
        if (self.showsPaging && (self.currentPage != self.maxPages && indexPath.row == self.posts.count - 1)) {
            [self loadPosts:++self.currentPage];
        }
        
        PPPostTableViewCell *postCell = (PPPostTableViewCell *)cell;
        
        if (indexPath.row != self.posts.count) {
            if ([self.posts[indexPath.row] upvoted]) {
                [postCell.upvoteButton setImage:[UIImage imageNamed:@"pop-popcorn"] forState:UIControlStateNormal];
                [postCell.upvoteButton setUserInteractionEnabled:NO];
            }
            else {
                [postCell.upvoteButton setImage:[UIImage imageNamed:@"pop-kernel"] forState:UIControlStateNormal];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showsPaging && indexPath.row == self.posts.count) {
        UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:kPPLoadingCellIdentifier];
        
        if (loadingCell == nil) {
            loadingCell = [[PPPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPPLoadingCellIdentifier];
        }
        
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[loadingCell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
        
        loadingCell.separatorInset = UIEdgeInsetsMake(0, loadingCell.bounds.size.width, 0, 0);
        
        return loadingCell;
    }
    
    PPPostTableViewCell *cell = (PPPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPPPostCellIdentifier];
    if (cell == nil) {
        cell = [[PPPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPPPostCellIdentifier];
    }
    
    if (self.posts.count == 0) {
        PPPost *empty = [PPPost new];
        
        PPPostAddressee *placeholder = [PPPostAddressee new];
        placeholder.name = PraisePopAPI.isReachable ? @"You" : @"Internet Connection";
        
        empty.addressee = placeholder;
        
        empty.body = self.state == PP3DGlassesRefreshControlStateRefreshing ? self.loadingMessage : (PraisePopAPI.isReachable ? self.lonelyMessage : self.unreachableMessage);
        empty.upvoted = YES;
        empty.createdAt = NSDate.date;
        
        cell.post = empty;
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    cell.post = self.posts[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    cell.userInteractionEnabled = YES;
    
    return cell;
}

#pragma mark - PPPostDelegate

- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath {
    if (![self.posts[indexPath.row] upvoted]) {
        [[PraisePopAPI sharedClient] upvote:self.posts[indexPath.row] success:^(BOOL result) {
            [self.posts[indexPath.row] setUpvoted:result];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.posts[indexPath.row] setUpvoted:NO];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [error pp_showError];
            [PraisePopAPI hideActivityIndicator];
        }];
    }
}

- (void)didTapMore:(NSIndexPath *)indexPath {
    UIActionSheet *actions;
    
    if ([self.posts[indexPath.row] isFromCurrentUser]) {
        actions = [[UIActionSheet alloc] initWithTitle:@"Options"
                                              delegate:nil
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:@"Delete"
                                      otherButtonTitles:nil];
        actions.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self deletePost:self.posts[indexPath.row]];
            }
        };
    }
    else if ([self.posts[indexPath.row] isDeletable]) {
        actions = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Delete"
                                               otherButtonTitles:@"Report", nil];
        
        
        actions.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self deletePost:self.posts[indexPath.row]];
            }
            else if (buttonIndex == 1) {
                [self flagPost:self.posts[indexPath.row]];
            }
        };
    }
    else {
       actions = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Report", nil];
        actions.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self flagPost:self.posts[indexPath.row]];
            }
        };
    }
    
    actions.actionSheetStyle = UIActionSheetStyleDefault;
    [actions showInView:self.view];
}

- (void)deletePost:(PPPost *)post {
    [[PraisePopAPI sharedClient] delete:post success:^(BOOL result) {
        if (result) {
            [self.posts removeObjectAtIndex:[self.posts indexOfObject:post]];
            [self.tableView reloadData];
        }
        else {
            [NSError pp_showErrorAlertWithMessage:@"We were unable to delete your post.  Please check your connection and try again"];
        }
    } failure:nil];
}

- (void)flagPost:(PPPost *)post {
    [[PraisePopAPI sharedClient] flag:post success:^(BOOL result) {
        if (result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"By reporting this post, you have made PraisePop a safer place." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
        else {
            [NSError pp_showErrorAlertWithMessage:@"We were unable to report this post.  Please check your connection and try again."];
        }
    } failure:nil];

}

#pragma mark - PPComposerDelegate

- (void)didPost {
    [super refresh];
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
    NSString *body;
    
    if (self.posts.count != 0) {
        body = [self.posts[indexPath.row] body];
    }
    else {
        body = PraisePopAPI.isReachable ? self.lonelyMessage : self.unreachableMessage;
    }
    
    NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:body attributes:[PPUnselectableTextView attributes]];
    CGFloat width = self.view.width * kPPPopCellTextViewRatio;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    return rect.size.height;
}

- (NSString *)loadingMessage {
    return @"Popping some fresh popcorn for you right now!  Please sit tight!";
}

- (NSString *)unreachableMessage {
    return @"I miss you. Come back to me so PraisePop can load its feed. Thanks for being there for me at other times, though!";
}

- (NSString *)lonelyMessage {
    return @"What are you looking at me for? My feed is currently empty! Fill it up with some positivity!";
}

@end
