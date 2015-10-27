//
//  UIView+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PPExtensions)

/**
 *  The x value of the frame.
 *
 *  @return The value
 */
- (CGFloat)x;
/**
 *  The y value of the frame.
 *
 *  @return The value.
 */
- (CGFloat)y;

/**
 *  The width of the frame.
 *
 *  @return The value.
 */
- (CGFloat)width;
/**
 *  The height of the frame.
 *
 *  @return The value.
 */
- (CGFloat)height;

/**
 *  Sets the y value of the view.
 *
 *  @param newY The new value.
 */
- (void)setY:(CGFloat)newY;
/**
 *  Sets the x value of the view.
 *
 *  @param newX The new value.
 */
- (void)setX:(CGFloat)newX;


/**
 *  Sets the width  of the view.
 *
 *  @param newWidth The new value.
 */
- (void)setWidth:(CGFloat)newWidth;
/**
 *  Sets the height value of the view.
 *
 *  @param newHeight The new value.
 */
- (void)setHeight:(CGFloat)newHeight;

@end
