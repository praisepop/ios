//
//  UIImage+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/25/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UIImage+PPExtensions.h"

@implementation UIImage (PPExtensions)

+ (instancetype)pp_maskedImageWithName:(NSString *)name color:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
