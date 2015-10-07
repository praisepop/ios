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

@property (strong, nonatomic) IBOutlet PPUnselectableTextView *textView;


@end

@implementation PPPopTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setPost:(PPPost *)post {
    self.textView.text = post.body;
}

@end
