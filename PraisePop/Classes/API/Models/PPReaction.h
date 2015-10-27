//
//  PPReaction.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//
//

#import <Mantle/Mantle.h>

/**
 *  Possible reaction types for a post.
 */
typedef NS_ENUM(NSUInteger, PPReactionType) {
    /**
     *  Text, raw plain text.
     */
    PPReactionText,
    /**
     *  Emoji -- stored as unicode, but displays as image.
     */
    PPReactionEmoji
};

@interface PPReaction : MTLModel <MTLJSONSerializing>

/**
 *  The ID of the reaction as stored in the database.
 */
@property (strong, nonatomic) NSString *_id;
/**
 *  The post that the reaction belongs to.
 */
@property (strong, nonatomic) NSString *post_id;
/**
 *  The actual reaction, if emoji it will be displayed as image.
 */
@property (strong, nonatomic) NSString *reaction;

/**
 *  The reaction type: emoji or text.
 */
@property (nonatomic) PPReactionType type;

/**
 *  The date and time that the post was updated.
 */
@property (strong, nonatomic) NSDate *updatedAt;
/**
 *  The date and time that the post was created.  Used for time ago label.
 */
@property (strong, nonatomic) NSDate *createdAt;
/**
 *  The date and time that the post was fetched from the database.
 */
@property (strong, nonatomic) NSDate *retrievedAt;

@end
