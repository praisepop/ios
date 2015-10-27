//
//  PPComposeViewController.h
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPComposeViewController;

@protocol PPComposerDelegate <NSObject>

@optional;

/**
 *  Tells a implementer if a new post has been create,
 *  so the controller can react accodringly.
 */
- (void)didPost;

@end

@interface PPComposeViewController : UIViewController

/**
 *  The PPComposerDelegate.
 */
@property (weak, nonatomic) id<PPComposerDelegate> delegate;

@end
