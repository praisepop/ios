//
//  PPComposeBar.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPComposeBar.h"

@interface PPComposeBar ()

@end

@implementation PPComposeBar

- (IBAction)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelPost)]) {
        [self.delegate didCancelPost];
    }
}

- (IBAction)send:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendPost)]) {
        [self.delegate didSendPost];
    }
}

- (IBAction)type:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPostType)]) {
        [self.delegate didSelectPostType];
    }
}


@end
