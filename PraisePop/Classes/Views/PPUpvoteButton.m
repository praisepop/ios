//
//  PPUpvoteButton.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/31/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPUpvoteButton.h"

CGFloat const kPPUpvoteAnimationDuration = 0.4;

@interface PPUpvoteButton ()

@end

@implementation PPUpvoteButton

- (void)awakeFromNib {
    self.animationImages = [[PraisePop shared] animationImages];
    self.animationDuration = kPPUpvoteAnimationDuration;
    self.animationRepeatCount = 1;
}

- (void)setState:(PPImageState)state {
    if (state == PPImageStateKernel) {
        self.image = [UIImage imageNamed:@"pop-kernel"];
        self.userInteractionEnabled = YES;
    }
    else {
        self.image = [UIImage imageNamed:@"pop-popcorn"];
        self.userInteractionEnabled = NO;
    }
}

- (void)setSelected:(BOOL)selected {
    self.state = selected ? PPImageStatePopcorn : PPImageStateKernel;
}

- (void)startAnimatingWithCallback:(void (^)())completion {
    self.state = PPImageStatePopcorn;
    [self startAnimating];
    
    dispatch_queue_t animatingQueue = dispatch_get_main_queue();
    dispatch_queue_t pollingQueue = dispatch_queue_create("pollingQueue", NULL);
    dispatch_async(pollingQueue, ^{
        while (self.isAnimating) {
            usleep(10000);
        }
        
        dispatch_async(animatingQueue, ^{
            if (completion) {
                completion();
            }
        });
    });
}

@end
