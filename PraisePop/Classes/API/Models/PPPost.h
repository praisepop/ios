//
//  PPPost.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPUser;
@class PPOrganization;

#import "PPPostAddressee.h"

typedef NS_ENUM(NSUInteger, PPPostType) {
    PPPostInvite,
    PPPostShoutout,
    PPPostAnnouncement
};

@interface PPPost : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *from_id;
@property (strong, nonatomic) NSString *body;

@property (strong, nonatomic) PPOrganization *organization;

@property (strong, nonatomic) NSArray *hashtags;

@property (nonatomic) PPPostType type;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *retrievedAt;

@property (strong, nonatomic) PPPostAddressee *addressee;
@property (strong, nonatomic) NSString *name;

@end
