//
//  PraisePopAPI.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import <UIKit/UIKit.h>

@interface PraisePopAPI : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

//- (void)signup:(NSDictionary *)attributes withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)posts:(void (^)(NSArray *posts))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
