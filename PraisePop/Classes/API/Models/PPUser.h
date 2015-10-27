//
//  PPUser.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPOrganization;

@interface PPUser : MTLModel <MTLJSONSerializing>

/**
 *  The ID of the user as stored in the database.
 */
@property (strong, nonatomic) NSString *_id;
/**
 *  The user's email.
 */
@property (strong, nonatomic) NSString *email;

/**
 *  The users name, as first and last keys.
 */
@property (strong, nonatomic) NSDictionary *name;

/**
 *  Whether or not the user is an admin.
 */
@property (nonatomic) BOOL admin;

/**
 *  The date and time that the user was updated.
 */
@property (strong, nonatomic) NSDate *updatedAt;
/**
 *  The date and time that the user was created.
 */
@property (strong, nonatomic) NSDate *createdAt;
/**
 *  The date and time that the user was fetched from the database.
 */
@property (strong, nonatomic) NSDate *retrievedAt;

/**
 *  An array of organization models that the user belongs to.
 */
@property (strong, nonatomic) NSArray *organizations;

/**
 *  The full name of the user (first and last).
 *
 *  @return The user's full name.
 */
- (NSString *)fullName;

@end
