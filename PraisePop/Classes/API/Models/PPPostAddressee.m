//
//  PPPostAddressee.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/24/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPPostAddressee.h"

#import "PPUser.h"

@implementation PPPostAddressee

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name" : @"name",
             @"user" : @"id"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PPUser.class];
}

- (NSString *)displayName {
    if (self.name.length == 0) {
        return [self.user.fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    return [self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
