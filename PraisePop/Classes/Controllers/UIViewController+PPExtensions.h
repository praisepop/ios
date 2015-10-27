//
//  UIViewController+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SWRevealViewController/SWRevealViewController.h>

@interface UIViewController (PPExtensions)

/**
 *  Sets the title with appropriate kerning and font size.
 *
 *  @param title The title to set.
 */
- (void)pp_setTitle:(NSString *)title;

/**
 *  Dismisses the parent view controller.
 */
- (void)pp_dismiss;

@end
