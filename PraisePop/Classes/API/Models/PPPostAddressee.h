//
//  PPPostAddressee.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/24/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPUser;

@interface PPPostAddressee : MTLModel <MTLJSONSerializing>

/**
 *  The name of the user.  If there is no user with ID.
 */
@property (strong, nonatomic) NSString *name;

/**
 *  The user to which the post is addressed.
 */
@property (strong, nonatomic) PPUser *user;

/**
 *  Returns the name of an addressee, as not all addressees have ID
 *  values in which to populate the user field from.
 *
 *  @return The name to use in the to field for a post.
 */
- (NSString *)displayName;

@end
