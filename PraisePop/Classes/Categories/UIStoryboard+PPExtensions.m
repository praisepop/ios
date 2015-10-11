//
//  UIStoryboard+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/11/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UIStoryboard+PPExtensions.h"

@implementation UIStoryboard (PPExtensions)

+ (UIViewController *)pp_controllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
