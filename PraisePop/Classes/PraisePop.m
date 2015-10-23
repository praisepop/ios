//
//  PraisePop.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PraisePop.h"

@implementation PraisePop


+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_sharedDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter = NSDateFormatter.new;
    });
    
    return _sharedDateFormatter;
}

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
