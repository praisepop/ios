//
//  PPAuthentication.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/24/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPAuthentication.h"

#import "PPUser.h"

@implementation PPAuthentication

#pragma mark - Mantle Methods

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"user" : @"user",
             @"token" : @"token"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PPUser.class];
}

@end
