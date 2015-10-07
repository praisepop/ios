//
//  UITableViewController+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (PPExtensions)

- (void)addReveal;

- (void)pp_setTitle:(NSString *)title;

- (UIViewController *)pp_controllerWithIdentifier:(NSString *)identifier;

@end
