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

@implementation PPPost
//
//- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
//    if (self = [super initWithDictionary:dictionaryValue error:error]) {
//        self.retrievedAt = NSDate.date;
//    }
//    
//    return self;
//}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"_id" : @"_id",
             @"from_id" : @"from",
             @"body" : @"body",
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

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"INVITE": @(PPPostInvite),
                                                                           @"ANNOUNCEMENT": @(PPPostAnnouncement),
                                                                           @"SHOUTOUT": @(PPPostShoutout)
                                                                           }];
}

@end
