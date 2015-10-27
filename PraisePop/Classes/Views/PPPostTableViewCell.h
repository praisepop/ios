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

- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath;

- (void)didTapMore:(NSIndexPath *)indexPath;

@end

@interface PPPostTableViewCell : UITableViewCell

#pragma mark - Outlets

@property (strong, nonatomic) IBOutlet UIButton *upvoteButton;

@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

#pragma mark - Delegate

@property (weak, nonatomic) id<PPPostDelegate> delegate;

#pragma mark - Properties

@property (assign, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) PPPost *post;

- (void)unvote;

@end
