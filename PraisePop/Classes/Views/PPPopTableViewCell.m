//
//  PPPopTableViewCell.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPPopTableViewCell.h"

#import "PPPost.h"

@interface PPPopTableViewCell ()

@property (strong, nonatomic) IBOutlet UIButton *upvoteButton;
@property (strong, nonatomic) IBOutlet PPUnselectableTextView *textView;


@end

@implementation PPPopTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setPost:(PPPost *)post {
    self.textView.text = post.body;
    
    self.addresseeLabel.text = [NSString stringWithFormat:@"To %@", post.addressee.displayName];
}

- (IBAction)upvoteTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [button setImage:[UIImage imageNamed:@"pop-popcorn"] forState:UIControlStateNormal];
    
    button.imageView.animationImages = self.images;
    button.imageView.animationDuration = 0.4;
    button.imageView.animationRepeatCount = 1;
    
    [button.imageView startAnimating];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpvotePop:atIndexPath:)]) {
        [self.delegate didUpvotePop:self.post atIndexPath:self.indexPath];
    }
}

- (NSArray *)images {
    NSMutableArray *images = NSMutableArray.array;
    
    for (int i = 0; i < 44; i ++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pop-%d", i]]];
    }
    
    return images;
}

@end
