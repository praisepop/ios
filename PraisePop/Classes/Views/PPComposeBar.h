//
//  PPComposeBar.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/26/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPComposeBar;

@protocol PPComposeBarDelegate <NSObject>

@optional

- (void)didCancelPost;

- (void)didSendPost;

- (void)didSelectPostType;

@end

@interface PPComposeBar : UIView

@property (strong, nonatomic) IBOutlet UIButton *typeButton;

@property (strong, nonatomic) IBOutlet UILabel *characterCounter;

@property (weak, nonatomic) id<PPComposeBarDelegate> delegate;

@end
