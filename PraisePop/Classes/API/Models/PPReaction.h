//
//  PPReaction.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, PPReactionType) {
    PPReactionText,
    PPReactionEmoji
};

@interface PPReaction : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *post_id;

@property (nonatomic) PPReactionType type;

@property (strong, nonatomic) NSString *reaction;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *retrievedAt;

@end
