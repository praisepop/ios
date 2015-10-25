//
//  PraisePopAPI.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPUser.h"
#import "PPOrganization.h"
#import "PPPost.h"
#import "PPAuthentication.h"
#import "PPReaction.h"

#import "PraisePopAPI.h"

static NSString * const PraisePopAPIBaseURLString = @"http://localhost:8080/api/v1/";

static CGFloat const PRAISE_POP_FEED_LIMIT = 25;

@interface PraisePopAPI ()

@property (nonatomic) NSUInteger currentPage;

@end

@implementation PraisePopAPI

+ (instancetype)sharedClient {
    static PraisePopAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PraisePopAPI alloc] initWithBaseURL:[NSURL URLWithString:PraisePopAPIBaseURLString]];
        _sharedClient.responseSerializer.acceptableStatusCodes = [_sharedClient.acceptableStatusCodes copy];
    });
    
    return _sharedClient;
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"users/authenticate" : [PPAuthentication class],
             @"orgs/*/users/random" : [PPUser class],
             @"orgs/*/posts" : [PPPost class]
             };
}

- (NSIndexSet *)acceptableStatusCodes {
    NSMutableIndexSet *acceptedCodes = [[NSMutableIndexSet alloc]
                                        initWithIndexSet:self.responseSerializer.acceptableStatusCodes];
    
    NSIndexSet *acceptable = [NSIndexSet.alloc initWithIndexesInRange:NSMakeRange(100, 600)];
    
    [acceptedCodes addIndexes:acceptable];
    
    return acceptedCodes;
}

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *paramters = @{
                                @"email" : email,
                                @"password" : password
                                };
    
    [self POST:@"users/authenticate" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            PPAuthentication *authentication = [MTLJSONAdapter modelOfClass:PPAuthentication.class fromJSONDictionary:response error:nil];
            [PraisePop saveToken:authentication.token email:authentication.user.email];
            [PraisePop saveOrganizations:authentication.user.organizations];
            [PraisePop saveUserAccount:authentication.user];
            success(YES);
        }
    } failure:failure];
}

- (void)posts:(void (^)(BOOL, NSArray *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSString *path = [NSString stringWithFormat:@"orgs/%@/posts", PraisePop.parentOrganizationID];

    NSDictionary *paramters = @{
                            @"token" : PraisePop.userToken,
                            @"limit" : @(PRAISE_POP_FEED_LIMIT),
                            @"page" : @(1)
                            };

    [self GET:path parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO, nil);
        }
        else {
            NSMutableArray *posts = [@[] mutableCopy];
            for (NSDictionary *aPost in response[@"data"]) {
                PPPost *post = [MTLJSONAdapter modelOfClass:PPPost.class fromJSONDictionary:aPost error:nil];
                [posts addObject:post];
            }
            
            success(YES, posts);
        }
    } failure:failure];
}



- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

@end
