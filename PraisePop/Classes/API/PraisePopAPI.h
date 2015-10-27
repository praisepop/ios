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

+ (instancetype)sharedClient;

#pragma mark - Authentication

- (void)signup:(NSString *)email password:(NSString *)password name:(NSDictionary *)name success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Post Methods

- (void)post:(PPPost *)post success:(void (^)(BOOL result, PPPost *post))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)posts:(void (^)(BOOL result, NSArray *posts))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Compose
- (void)send:(NSString *)postBody type:(NSString *)postType recepient:(NSDictionary *)recipient hashtags:(NSArray *)hashtags success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Post Actions
- (void)upvote:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)flag:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)delete:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Helpers

- (NSString *)md5:(NSString *)input;

@end
