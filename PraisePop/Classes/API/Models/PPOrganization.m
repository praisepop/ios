//
//  PPOrganization.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//
//

#import "PPOrganization.h"

@implementation PPOrganization

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    if (self = [super initWithDictionary:dictionaryValue error:error]) {
        self.retrievedAt = NSDate.date;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self._id forKey:@"_id"];
    [encoder encodeObject:self.domain forKey:@"domain"];
    [encoder encodeObject:@(self.parent) forKey:@"parent"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self._id = [decoder decodeObjectForKey:@"_id"];
        self.domain = [decoder decodeObjectForKey:@"domain"];
        self.parent = [[decoder decodeObjectForKey:@"parent"] boolValue];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"_id" : @"_id",
             @"domain" : @"domain",
             @"updatedAt" : @"updated_at",
             @"createdAt" : @"created_at",
             @"parent" : @"parent"
             };
}

+ (NSValueTransformer *)parentJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
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

@end
