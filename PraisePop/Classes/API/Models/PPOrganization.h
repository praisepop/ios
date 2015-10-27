//
//  PPOrganization.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//
//

#import <Mantle/Mantle.h>

@interface PPOrganization : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *domain;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *retrievedAt;

@property (nonatomic) BOOL parent;

@end
