//
//  UIStoryboard+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/11/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (PPExtensions)

/**
 *  Convenience method to get a contoller from a storyboard.
 *
 *  @param identifier The controller identifier.
 *
 *  @return The controller from a storyboard.
 */
+ (UIViewController *)pp_controllerWithIdentifier:(NSString *)identifier;

@end
