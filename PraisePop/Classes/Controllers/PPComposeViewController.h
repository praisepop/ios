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

- (void)didPost;

@end

@interface PPComposeViewController : UIViewController

@property (weak, nonatomic) id<PPComposerDelegate> delegate;

@end
