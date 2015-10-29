//
//  PPPostTableViewCell.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPostTableViewCell;

@protocol PPPostDelegate <NSObject>

@optional

/**
 *  Triggered when the upvote button was tapped for a post.
 *
 *  @param post      The post.
 *  @param indexPath The indexPath of the cell.
 */
- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath;

/**
 *  Triggered when the more button was tapped for a post.
 *
 *  @param indexPath The indexPath of the cell.
 */
- (void)didTapMore:(NSIndexPath *)indexPath;

@end

@interface PPPostTableViewCell : UITableViewCell

#pragma mark - Outlets

/**
 *  The upvote button of the cell.
 */
@property (strong, nonatomic) IBOutlet UIButton *upvoteButton;

/**
 *  The lable which shows how long ago a post was posted.
 */
@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

#pragma mark - Delegate

/**
 *  The cell delegate, which handles upvoting and more actions.
 */
@property (weak, nonatomic) id<PPPostDelegate> delegate;

#pragma mark - Properties

/**
 *  The indexPath of the cell.
 */
@property (assign, nonatomic) NSIndexPath *indexPath;

/**
 *  The post attached to the cell.
 */
@property (strong, nonatomic) PPPost *post;

@end
