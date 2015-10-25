//
//  PPPopTableViewCell.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPost;

#import "PPUnselectableTextView.h"

@class PPPopTableViewCell;

@protocol PPPopDelegate <NSObject>

@optional

- (void)didUpvotePop:(PPPost *)pop atIndexPath:(NSIndexPath *)indexPath;

@end

@interface PPPopTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *addresseeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (weak, nonatomic) id<PPPopDelegate> delegate;

@property (assign, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) PPPost *post;

@property (nonatomic) BOOL upvoted;

@end
