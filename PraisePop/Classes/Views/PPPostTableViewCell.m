//
//  PPPostTableViewCell.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//


#import <DateTools/NSDate+DateTools.h>

#import "PPPost.h"

#import "PPUnselectableTextView.h"
#import "PPUpvoteButton.h"

#import "PPPostTableViewCell.h"

@interface PPPostTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *addresseeLabel;

@property (strong, nonatomic) IBOutlet PPUnselectableTextView *textView;

@end

@implementation PPPostTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self.class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(upvoteTapped)];
    [self.upvoteButton addGestureRecognizer:tap];
}

- (void)setPost:(PPPost *)aPost {
    _post = aPost;
    
    self.upvoteButton.selected = aPost.upvoted;
    self.textView.text = self.post.body;
    self.addresseeLabel.text = [NSString pp_addressString:self.post.addressee.displayName];
    self.timeAgoLabel.text = [NSString pp_dateString:self.post.createdAt.shortTimeAgoSinceNow];
}

- (void)setUpvoted:(BOOL)upvoted {
    if (upvoted) {
        self.upvoteButton.state = PPImageStatePopcorn;
    }
    else {
        self.upvoteButton.state = PPImageStateKernel;
    }
}

- (void)upvoteTapped {
    self.upvoteButton.userInteractionEnabled = NO;
    [self.upvoteButton startAnimatingWithCallback:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUpvotePost:atIndexPath:)]) {
            [self.delegate didUpvotePost:self.post atIndexPath:self.indexPath];
        }
    }];
}

- (IBAction)moreTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMore:)]) {
        [self.delegate didTapMore:self.indexPath];
    }
}

@end
