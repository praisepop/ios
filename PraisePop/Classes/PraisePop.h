//
//  PraisePop.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PraisePop : NSObject

+ (NSDateFormatter *)dateFormatter;

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier;

@end
