//
//  NSError+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (PPExtensions)

- (void)pp_showError;

+ (void)pp_showErrorAlertWithMessage:(NSString *)message;

@end
