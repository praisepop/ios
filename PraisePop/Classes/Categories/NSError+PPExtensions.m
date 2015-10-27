//
//  NSError+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "NSError+PPExtensions.h"

@implementation NSError (PPExtensions)

- (void)pp_showError {
    [NSError pp_showErrorAlertWithMessage:self.localizedDescription];
}

+ (void)pp_showErrorAlertWithMessage:(NSString *)message {
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error"
                                                message:message
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [a show];
}

@end
