//
//  PraisePopAPI.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>

@class PPPost;

@interface PraisePopAPI : AFHTTPRequestOperationManager

#pragma mark - Singleton

/**
 * A singleton object for the API.
 *
 *  @return The PraisePopAPI object.
 */
+ (instancetype)sharedClient;

#pragma mark - Authentication
/**
 *  Signs up a new user for PraisePop!
 *
 *  @param email    The email of the user.
 *  @param password The desired password of the user.
 *  @param name     The user's name.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)signup:(NSString *)email password:(NSString *)password name:(NSDictionary *)name success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  Log in an existing user.
 *
 *  @param email    The email of the user.
 *  @param password The password of the user.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Post Methods

/**
 *  Loads a single post from the database.
 *
 *  @param post    The post to find a single result of.
 *  @param success Whether or not the request was successful, and the resulting post.
 *  @param failure What to do if the request wasn't successful.
 */
- (void)post:(PPPost *)post success:(void (^)(BOOL result, PPPost *post))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  An array of posts from the database for a particular organization.
 *
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)posts:(void (^)(BOOL result, NSArray *posts))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Compose

/**
 *  Sends a new post to the server.
 *
 *  @param postBody  The text of the post.
 *  @param postType  The type of the post.
 *  @param recipient The recipient of the post.
 *  @param hashtags  An array of hashtags in the post.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)send:(NSString *)postBody type:(NSString *)postType recepient:(NSDictionary *)recipient hashtags:(NSArray *)hashtags success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Post Actions

/**
 *  Deletes a post (really hides it in database).
 *
 *  @param post     The post to delete.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)upvote:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  Flags a post for moderation.
 *
 *  @param post     The post to flag.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)flag:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  Deletes a post.
 *
 *  @param post     The post to delete.
 *  @param success  Whether or not the request was successful.
 *  @param failure  What to do if the request wasn't successful.
 */
- (void)delete:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Helpers

/**
 *  MD5s a string.
 *
 *  @param input The string to hash.
 *
 *  @return The hashed string.
 */
- (NSString *)md5:(NSString *)input;

/**
 *  Checks to see if the API is reachable.
 *
 *  @return Whether or not it's reachable.
 */
+ (BOOL)isReachable;

@end
