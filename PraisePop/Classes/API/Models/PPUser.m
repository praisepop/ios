//
//  PPUser.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPUser.h"

#import "PPOrganization.h"

@implementation PPUser

#pragma mark - Mantle Methods

+ (NSValueTransformer *)organizationsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:PPOrganization.class];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)adminJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [PraisePop.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - Encoding for Storage

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self._id forKey:@"_id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:@(self.admin) forKey:@"admin"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self._id = [decoder decodeObjectForKey:@"_id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.admin = [[decoder decodeObjectForKey:@"admin"] boolValue];
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"_id" : @"_id",
             @"email" : @"email",
             @"name" : @"name",
             @"updatedAt" : @"updated_at",
             @"createdAt" : @"created_at",
             @"organizations": @"orgs",
             @"admin" : @"admin"
             };
}

#pragma mark - Helpers

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.name[@"first"], self.name[@"last"]];
}

@end
