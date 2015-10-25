//
//  PPPostAddressee.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/24/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPUser;

@interface PPPostAddressee : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PPUser *user;

- (NSString *)displayName;

@end
