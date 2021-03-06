//
//  PPPost.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPPost.h"

#import "PPUser.h"
#import "PPOrganization.h"
#import "PPPostAddressee.h"

@implementation PPPost

#pragma mark - Mantle Methods

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"_id" : @"_id",
             @"from_id" : @"from",
             @"body" : @"body",
             @"upvoted" : @"upvoted",
             @"organization" : @"org",
             @"type" : @"type",
             @"hashtags" : @"hashtags",
             @"addressee" : @"to",
             @"updatedAt" : @"updated_at",
             @"createdAt" : @"created_at"
             };
}

+ (NSValueTransformer *)addresseeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PPPostAddressee.class];
}

+ (NSValueTransformer *)organizationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PPOrganization.class];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"INVITE": @(PPPostInvite),
                                                                           @"ANNOUNCEMENT": @(PPPostAnnouncement),
                                                                           @"SHOUTOUT": @(PPPostShoutout),
                                                                           @"UNCATEGORIZED": @(PPPostUncategorized)
                                                                           }];
}

#pragma mark - Helpers

- (BOOL)isDeletable {
    return [PraisePop.currentUser._id isEqualToString:self.addressee.user._id] ||
           [self.from_id isEqualToString:PraisePop.currentUser._id] ||
           PraisePop.currentUser.admin;
}

- (BOOL)isFromCurrentUser {
    return [PraisePop.currentUser._id isEqualToString:self.from_id];
}

@end
