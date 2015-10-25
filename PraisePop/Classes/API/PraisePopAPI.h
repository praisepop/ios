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

//- (void)signup:(NSDictionary *)attributes withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)posts:(void (^)(BOOL result, NSArray *posts))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)upvote:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
