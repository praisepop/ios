//
//  PPPost.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/23/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <Mantle/Mantle.h>

@class PPOrganization;
@class PPPostAddressee;

#import "PPPostAddressee.h"

/**
 *  Possible post types.
 */
typedef NS_ENUM(NSUInteger, PPPostType) {
    /**
     *  An invite, as in "Come to the great lawn for pizza!"
     *  Broadcasted to the general community.
     */
    PPPostInvite,
    /**
     *  A shoutout -- only broadcasted to a single user.
     */
    PPPostShoutout,
    /**
     *  Broadcastd to community, general announcements.
     */
    PPPostAnnouncement,
    /**
     *  No announcment, ambiguous post type.
     */
    PPPostUncategorized
};

@interface PPPost : MTLModel <MTLJSONSerializing>

/**
 *  The ID of the post as stored in the database.
 */
@property (strong, nonatomic) NSString *_id;
/**
 *  The ID of the user which composed the post.
 */
@property (strong, nonatomic) NSString *from_id;
/**
 *  The body of a post.
 */
@property (strong, nonatomic) NSString *body;
/**
 *  The name of the user to displasy as addressee.
 */
@property (strong, nonatomic) NSString *name;

/**
 *  Whether or not the current user has upvoted a post.
 */
@property (nonatomic) BOOL upvoted;

/**
 *  The organization in which the post was posted.
 */
@property (strong, nonatomic) PPOrganization *organization;

/**
 *  To whom the post is addressed.
 */
@property (strong, nonatomic) PPPostAddressee *addressee;

/**
 *  The type of post.
 */
@property (nonatomic) PPPostType type;

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

/**
 *  An array of hashtags (if any) in the post.  Format: [#hashtag, #example]
 */
@property (strong, nonatomic) NSArray *hashtags;

/**
 *  Tells us whether or not the post can be deleted...  If you are an
 *  admin, then you can delete any post (though not yet supported).
 *  Otherwise, you can only report a post (so you shouldn't see delete option).
 *
 *  @return Whether or not the post can be deleted.
 */
- (BOOL)isDeletable;

/**
 *  Tells us whether or not a post was authored by the current user.
 *
 *  @return Whether or not the post was authored by the current user.
 */
- (BOOL)isFromCurrentUser;

@end
