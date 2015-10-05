//
//  PraisePopAPI.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPUser.h"
#import "PPOrganization.h"
#import "PPUpvote.h"
#import "PPPost.h"

#import "PraisePopAPI.h"


static NSString * const PraisePopAPIBaseURLString = @"http://localhost:8080/api/v1/";

@implementation PraisePopAPI

+ (instancetype)sharedClient {
    static PraisePopAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PraisePopAPI alloc] initWithBaseURL:[NSURL URLWithString:PraisePopAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *paramters = @{@"email" : email, @"password" : password};
    
    [self POST:@"users/authenticate" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject[@"result"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"token"] forKey:@"token"];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)posts:(void (^)(NSArray *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *parameters = @{@"token":self.token};
    
    NSString *organizationId = @"561096efb6bc350000000003"; // MY TEMP ID
    NSString *url = [NSString stringWithFormat:@"organization/%@/posts", organizationId];
    
    [self POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSMutableArray *posts;
            
            for (NSDictionary *post in responseObject[@"data"]) {
                PPPost *aPost = [PPPost.alloc initWithAttributes:post];
                
                [posts addObject:aPost];
            }
            
            success(posts);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}



- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

@end
