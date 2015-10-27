//
//  UITableViewController+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (PPExtensions)

/**
 *  Adds a settings icon in the top left, which shows the
 *  reveal controller.
 */
- (void)addReveal;

/**
 *  Sets the title with appropriate kerning and font size.
 *
 *  @param title The title to set.
 */
- (void)pp_setTitle:(NSString *)title;

@end
