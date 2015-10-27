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

/**
 *  The user token.  Needed for every API request.
 */
@property (strong, nonatomic) NSString *token;

/**
 *  The user associated with the token.
 */
@property (strong, nonatomic) PPUser *user;

/**
 *  The date at which the object was retrieved from the API.
 */
@property (strong, nonatomic) NSDate *retrievedAt;

@end
