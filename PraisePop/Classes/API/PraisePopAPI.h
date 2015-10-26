//
//  PraisePopAPI.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Overcoat/Overcoat.h>
#import <SSKeychain/SSKeychain.h>

#import <UIKit/UIKit.h>

@class PAAuthentication;
@class PPPost;

@interface PraisePopAPI : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

- (void)signup:(NSString *)email withPassword:(NSString *)password andName:(NSDictionary *)name success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)posts:(void (^)(BOOL result, NSArray *posts))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)upvote:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)post:(NSString *)postBody type:(NSString *)postType recepient:(NSDictionary *)recipient hashtags:(NSArray *)hashtags success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)singlePost:(PPPost *)post success:(void (^)(BOOL result, PPPost *post))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)report:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)delete:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
