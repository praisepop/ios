//
//  PraisePop.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

@class PPOrganization;
@class PPUser;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PraisePop : NSObject

/**
 *  PraisePop singleton.
 *
 *  @return A new PraisePop instance.
 */
+ (instancetype)shared;

/**
 *  A shared date formatter (they are expensive to create).
 *
 *  @return The formatter.
 */
+ (NSDateFormatter *)dateFormatter;

/**
 *  Saves a user account in defaults.
 *
 *  @param user The user to save.
 */
+ (void)saveUserAccount:(PPUser *)user;
/**
 *  Saves the user organizations in defaults.
 *
 *  @param organizations The organizations to save.
 */
+ (void)saveOrganizations:(NSArray *)organizations;
/**
 *  Saves the user's email and token to the keychain.
 *
 *  @param token The token of the user.
 *  @param email The user's email.
 */
+ (void)saveToken:(NSString *)token email:(NSString *)email;

/**
 *  Retrieves the current token from the keychain.
 *
 *  @return The token of the current user.
 */
- (NSString *)userToken;

/**
 *  Decodes the current user from defaults.
 *
 *  @return The current user.
 */
+ (PPUser *)currentUser;

/**
 *  Loops through decoded organizations and returns the parent one.
 *
 *  @return The parent organization.
 */
+ (PPOrganization *)parentOrganization;
/**
 *  Loops through decoded organizations and returns the non parent one.
 *
 *  @return The child organization (if any).
 */
+ (PPOrganization *)childOrganization;

/**
 *  Destroys the user session, AKA wipes all stored organizations, users
 *  and removes the keychain data.
 */
+ (void)destorySession;

@end
