//
//  PP3DGlassesRefreshableController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PP3DGlassesRefreshableController.h"

@interface PP3DGlassesRefreshableController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *refreshLoadingView;

@property (strong, nonatomic) UIImageView *sparkle_spin_right;
@property (strong, nonatomic) UIImageView *sparkle_spin_left;
@property (strong, nonatomic) UIImageView *glasses_background;

@property (readwrite, nonatomic) PP3DGlassesRefreshControlState state;

@end

@implementation PP3DGlassesRefreshableController

- (void)viewDidLoad {
    [self setupRefreshControl];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = UIColor.pp_redColor;
    
    self.sparkle_spin_left = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"sparkle"]];
    self.sparkle_spin_right = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"sparkle"]];
    self.glasses_background = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"3d-glasses"]];
    
    [self.refreshLoadingView addSubview:self.sparkle_spin_left];
    [self.refreshLoadingView addSubview:self.sparkle_spin_right];
    [self.refreshLoadingView addSubview:self.glasses_background];
    
    self.refreshLoadingView.clipsToBounds = YES;
    
    self.refreshControl.tintColor = [UIColor clearColor];
    
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    self.state = PP3DGlassesRefreshControlStateIdle;
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh {
    self.state = PP3DGlassesRefreshControlStateRefreshing;
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(willBeginRefreshing)]) {
        [self.refreshDelegate willBeginRefreshing];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(didBeginRefreshing)]) {
            [self.refreshDelegate didBeginRefreshing];
        }
        self.state = PP3DGlassesRefreshControlStateResetting;
        [self.refreshControl endRefreshing];
        self.state = PP3DGlassesRefreshControlStateIdle;
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect refreshBounds = self.refreshControl.bounds;
    
    CGFloat pullDistance = MAX(0, -self.refreshControl.y);
    CGFloat midX = self.tableView.width / 2;
    
    CGFloat pullRatio = MIN(MAX(pullDistance, 0), 100) / 100;
    
    self.glasses_background.x = (midX - self.glasses_background.width/2);
    self.glasses_background.y = (pullDistance - self.glasses_background.height) / 2;
    
    self.sparkle_spin_left.x = pullRatio * self.glasses_background.x - self.sparkle_spin_left.width - 10;
    self.sparkle_spin_left.y = (pullDistance - self.sparkle_spin_left.height) / 2;
    
    self.sparkle_spin_right.x = midX * 2 - self.sparkle_spin_left.x - self.sparkle_spin_left.width;
    self.sparkle_spin_right.y = self.sparkle_spin_left.y;
    
    refreshBounds.size.height = pullDistance;
    self.refreshLoadingView.frame = refreshBounds;
    
    if (self.refreshControl.isRefreshing || self.state == PP3DGlassesRefreshControlStateRefreshing) {
        [self animateRefreshView];
    }
}

- (void)animateRefreshView {
    [UIView animateWithDuration:3.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.sparkle_spin_right.transform = CGAffineTransformRotate(self.sparkle_spin_right.transform, M_PI_2);
        self.sparkle_spin_left.transform = CGAffineTransformRotate(self.sparkle_spin_left.transform, -M_PI_2);
    } completion:^(BOOL finished) {
        if (self.refreshControl.isRefreshing) {
            [self animateRefreshView];
        }
        else {
            [self resetAnimation];
        }
    }];
}

- (void)resetAnimation {
    self.state = PP3DGlassesRefreshControlStateIdle;
}

- (void)setState:(PP3DGlassesRefreshControlState)state {
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(didChangeState:)]) {
        [self.refreshDelegate didChangeState:state];
    }
}

@end
