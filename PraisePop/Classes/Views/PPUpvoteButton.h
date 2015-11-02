//
//  PPUpvoteButton.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/31/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kPPUpvoteAnimationDuration;

typedef NS_ENUM(NSUInteger, PPImageState) {
    PPImageStateKernel,
    PPImageStatePopcorn
};

@interface PPUpvoteButton : UIImageView

@property (nonatomic) BOOL selected;

@property (nonatomic) PPImageState state;

- (void)startAnimatingWithCallback:(void (^)())completion;

@end
