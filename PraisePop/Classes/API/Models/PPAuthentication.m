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

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    if (self = [super initWithDictionary:dictionaryValue error:error]) {
        self.retrievedAt = NSDate.date;
    }
    
    return self;
}

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
