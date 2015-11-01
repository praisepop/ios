//
//  PraisePopAPI.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <SystemConfiguration/SCNetworkReachability.h>
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>
#import <Crashlytics/Crashlytics.h>
#import <Instabug/Instabug.h>

#import "PPUser.h"
#import "PPPost.h"
#import "PPReaction.h"
#import "PPAuthentication.h"
#import "PPOrganization.h"

#import "PraisePopAPI.h"

static NSString * const PraisePopAPIBaseURLString = @"https://api.trypraisepop.com/v1/";

static CGFloat const PRAISE_POP_FEED_LIMIT = 25;

@interface PraisePopAPI ()

@end

@implementation PraisePopAPI

NSString * NSStringFromObjectID(NSString *objectID) {
    return [NSString stringWithFormat:@"PPC%@", objectID];
}

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

- (void)signup:(NSString *)email password:(NSString *)password name:(NSDictionary *)name success:(void (^)(BOOL))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [PraisePopAPI showActivityIndicator];
    NSDictionary *paramters = @{
                                @"email" : email,
                                @"password" : [self md5:password],
                                @"name" : name
                                };
    
    [self POST:@"users/new" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [PraisePopAPI showActivityIndicator];
    NSDictionary *paramters = @{
                                @"email" : email,
                                @"password" : [self md5:password]
                                };
    
    [self POST:@"users/authenticate" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            PPAuthentication *authentication = [MTLJSONAdapter modelOfClass:PPAuthentication.class fromJSONDictionary:response error:nil];
            BOOL save = [PraisePop save:authentication];
            
            if (!save) {
                [PraisePop destorySession];
                success(NO);
                return;
            }
            
            [PFPush subscribeToChannelInBackground:NSStringFromObjectID(authentication.user._id) block:nil];
            [PFPush subscribeToChannelInBackground:NSStringFromObjectID(PraisePop.parentOrganization._id) block:nil];
            
            if (PraisePop.childOrganization) {
                [PFPush subscribeToChannelInBackground:PraisePop.childOrganization._id block:nil];
            }
            
            [CrashlyticsKit setUserIdentifier:authentication.user._id];
            [CrashlyticsKit setUserEmail:authentication.user.email];
            [CrashlyticsKit setUserName:authentication.user.fullName];
            
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)posts:(void (^)(BOOL result, NSArray *))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self posts:1 success:^(BOOL result, NSArray *posts, NSUInteger currentPage, NSUInteger totalPages, NSUInteger totalItems) {
        success(result, posts);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)posts:(NSUInteger)page success:(void (^)(BOOL, NSArray *, NSUInteger, NSUInteger, NSUInteger))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [PraisePopAPI showActivityIndicator];
    NSString *path = [NSString stringWithFormat:@"orgs/%@/posts", PraisePop.parentOrganization._id];
    
    for (int i = 0; [PraisePop shared].userToken.length == 0; i++) {
        if (i >= 10) {
            success(NO, nil, 0, 0, 0);
            break;
        }
    }
    
    NSDictionary *paramters = @{
                                @"token" : [PraisePop shared].userToken,
                                @"limit" : @(PRAISE_POP_FEED_LIMIT),
                                @"page" : @(page)
                                };
    
    [self GET:path parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO, nil, 0, 0, 0);
        }
        else {
            NSMutableArray *posts = [@[] mutableCopy];
            for (NSDictionary *aPost in response[@"data"]) {
                PPPost *post = [MTLJSONAdapter modelOfClass:PPPost.class fromJSONDictionary:aPost error:nil];
                [posts addObject:post];
            }
            
            NSDictionary *paging = response[@"paging"];
            
            NSUInteger currentPage = [paging[@"current_page"] integerValue];
            NSUInteger totalPages = [paging[@"page_count"] integerValue];
            NSUInteger totalItems = [paging[@"total_items"] integerValue];
            
            success(YES, posts, currentPage, totalPages, totalItems);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)upvote:(PPPost *)post success:(void (^)(BOOL result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [PraisePopAPI showActivityIndicator];
    NSString *path = [NSString stringWithFormat:@"posts/%@/upvote", post._id];
    
    NSDictionary *parameters = @{
                                 @"token" : [PraisePop shared].userToken
                                 };
    
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            success(YES);
        }
    } failure:failure];
}

- (void)send:(NSString *)postBody type:(NSString *)postType recepient:(NSDictionary *)recipient hashtags:(NSArray *)hashtags success:(void (^)(BOOL))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [PraisePopAPI showActivityIndicator];
    
    NSString *path = [NSString stringWithFormat:@"orgs/%@/posts/new", PraisePop.parentOrganization._id];
    
    NSDictionary *parameters = @{
                                 @"token" : [PraisePop shared].userToken,
                                 @"hashtags" : hashtags,
                                 @"to" : @{
                                     @"name" : recipient
                                 },
                                 @"body" : postBody,
                                 @"type" : postType
                                 };
    
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)post:(PPPost *)post success:(void (^)(BOOL, PPPost *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [PraisePopAPI showActivityIndicator];
    NSString *path = [NSString stringWithFormat:@"posts/%@", post._id];

    NSDictionary *parameters = @{
                                 @"token" : [PraisePop shared].userToken
                                 };
    
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO, nil);
        }
        else {
            PPPost *post = [MTLJSONAdapter modelOfClass:PPPost.class fromJSONDictionary:response error:nil];
            success(YES, post);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [PraisePopAPI hideActivityIndicator];
        [error pp_showError];
    }];
}

- (void)flag:(PPPost *)post success:(void (^)(BOOL))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [PraisePopAPI showActivityIndicator];
    NSString *path = [NSString stringWithFormat:@"posts/%@/flag", post._id];
    
    NSDictionary *parameters = @{
                                 @"token" : [PraisePop shared].userToken
                                 };
    
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

- (void)delete:(PPPost *)post success:(void (^)(BOOL))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [PraisePopAPI showActivityIndicator];
    NSString *path = [NSString stringWithFormat:@"posts/%@", post._id];
    
    NSDictionary *parameters = @{
                                 @"token" : [PraisePop shared].userToken
                                 };
    
    [self DELETE:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [PraisePopAPI hideActivityIndicator];
        
        if (response[@"result"] && [response[@"result"] boolValue] == NO) {
            success(NO);
        }
        else {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [error pp_showError];
        [PraisePopAPI hideActivityIndicator];
    }];
}

#pragma mark - Helpers

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (BOOL)isReachable {
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com");
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

+ (void)showActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
