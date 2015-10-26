//
//  UIImage+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/25/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PPExtensions)

+ (instancetype)pp_maskedImageWithName:(NSString *)name color:(UIColor *)color;

@end
