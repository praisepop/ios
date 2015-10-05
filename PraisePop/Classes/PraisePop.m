//
//  PraisePop.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PraisePop.h"

@implementation PraisePop

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
