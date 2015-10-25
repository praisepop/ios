//
//  PPReaction.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//
//

#import "PPReaction.h"

@implementation PPReaction

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    if (self = [super initWithDictionary:dictionaryValue error:error]) {
        self.retrievedAt = NSDate.date;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"_id" : @"_id",
             @"post_id" : @"post",
             @"type" : @"type",
             @"reaction" : @"reaction",
             @"updatedAt" : @"updated_at",
             @"createdAt" : @"created_at"
             };
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
                                                                           @"TEXT": @(PPReactionText),
                                                                           @"EMOJI": @(PPReactionEmoji)
                                                                           }];
}

@end
