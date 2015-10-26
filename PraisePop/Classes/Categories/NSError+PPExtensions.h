//
//  NSError+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (PPExtensions)

- (void)showError;

+ (void)showErrorAlertWithMessage:(NSString *)message;

@end
