//
//  PPUnselectableTextView.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPUnselectableTextView.h"

@implementation PPUnselectableTextView

- (void)layoutSubviews {
    self.editable = NO;
    self.userInteractionEnabled = NO;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
}

- (void)setText:(NSString *)text {
    self.attributedText = [NSAttributedString.alloc initWithString:text attributes:[PPUnselectableTextView attributes]];
}

+ (NSDictionary *)attributes {
    NSMutableParagraphStyle *paragrapStyle = NSMutableParagraphStyle.new;
    paragrapStyle.alignment = NSTextAlignmentLeft;
    paragrapStyle.lineSpacing = 3;
    
    return @{
             NSFontAttributeName : [UIFont pp_fontWithName:FuturaBook size:17],
             NSParagraphStyleAttributeName : paragrapStyle
             };
}

@end
