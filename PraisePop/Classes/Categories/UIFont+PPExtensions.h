//
//  UIFont+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Custom fonts.
 */
typedef NS_ENUM(NSInteger, PPFont) {
    /**
     *  Futura Medium.
     */
    FuturaMedium,
    /**
     *  Futura Book.
     */
    FuturaBook,
    /**
     *  Futura Bold.
     */
    FuturaBold
};

@interface UIFont (PPExtensions)

/**
 *  Serves us one of our custom fonts in the appropriate size.
 *
 *  @param font The font name.
 *  @param size The font size.
 *
 *  @return Our desired font.
 */
+ (UIFont *)pp_fontWithName:(PPFont)font size:(CGFloat)size;

@end
