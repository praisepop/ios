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

/**
 *  Triggered when the cancel button is pressed.
 */
- (void)didCancelPost;
/**
 *  Triggered when the send button is pressed.
 */
- (void)didSendPost;
/**
 *  Triggered when the post type is selected.
 */
- (void)didSelectPostType;

@end

@interface PPComposeBar : UIView

/**
 *  The button that allows selection of a post type.
 */
@property (strong, nonatomic) IBOutlet UIButton *typeButton;

/**
 *  The character counter label, changes with each keystroke.
 */
@property (strong, nonatomic) IBOutlet UILabel *characterCounter;

/**
 *  The delegate of our compose bar.
 */
@property (weak, nonatomic) id<PPComposeBarDelegate> delegate;

@end
