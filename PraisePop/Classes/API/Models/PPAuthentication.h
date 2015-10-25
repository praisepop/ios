//
//  PPAuthentication.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/24/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPUser;

@interface PPAuthentication : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) PPUser *user;

@property (strong, nonatomic) NSDate *retrievedAt;

@end
