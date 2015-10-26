//
//  PPPostTableViewCell.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPost;

#import "PPUnselectableTextView.h"

@class PPPostTableViewCell;

@protocol PPPopDelegate <NSObject>

@optional

- (void)didUpvotePost:(PPPost *)post atIndexPath:(NSIndexPath *)indexPath;

- (void)didTapMore:(NSIndexPath *)indexPath;

@end

@interface PPPostTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *upvoteButton;
@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (weak, nonatomic) id<PPPopDelegate> delegate;

@property (assign, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) PPPost *post;

- (void)unvote;

@end
