//
//  UIFont+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UIFont+PPExtensions.h"

@implementation UIFont (PPExtensions)

+ (UIFont *)pp_fontWithName:(PPFont)font size:(CGFloat)size {
    NSString *fontName;
    
    switch (font) {
        case FuturaBold:
            fontName = @"Futura-Bold";
            break;
        case FuturaBook:
            fontName = @"Futura-Book";
            break;
        default:
            fontName = @"Futura-Medium";
            break;
    }
    
    return [UIFont fontWithName:fontName size:size];
}

@end
