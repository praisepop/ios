//
//  NSError+PPExtensions.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (PPExtensions)

/**
 *  Shows an error, with the localized description.
 */
- (void)pp_showError;

/**
 *  Shows an error with the title being, "Failure."
 *
 *  @param message The error message.
 */
+ (void)pp_showErrorAlertWithMessage:(NSString *)message;

@end
