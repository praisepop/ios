//
//  UIImage+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/25/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PPExtensions)

/**
 *  Returns an image masked with a color.
 *
 *  @param name  The name of the image.
 *  @param color The color to mask the image with.
 *
 *  @return The masked image.
 */
+ (instancetype)pp_maskedImageWithName:(NSString *)name color:(UIColor *)color;

@end
