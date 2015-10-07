//
//  UIFont+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PPFont) {
    FuturaMedium,
    FuturaBook,
    FuturaBold
};

@interface UIFont (PPExtensions)

+ (UIFont *)pp_fontWithName:(PPFont)font size:(CGFloat)size;

@end
