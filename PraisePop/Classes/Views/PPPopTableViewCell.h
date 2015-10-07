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

@interface PPPopTableViewCell : UITableViewCell

@property (strong, nonatomic) PPPost *post;

@end
