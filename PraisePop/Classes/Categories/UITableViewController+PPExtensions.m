//
//  UITableViewController+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/7/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UITableViewController+PPExtensions.h"

@implementation UITableViewController (PPExtensions)

- (void)pp_setTitle:(NSString *)title {
    self.tableView.showsVerticalScrollIndicator = NO;
    
    title = [title uppercaseString];
    
    UILabel *label = [UILabel.alloc initWithFrame:self.navigationItem.titleView.frame];
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont pp_fontWithName:FuturaBold size:25.0],
                                 NSKernAttributeName: @3
                                 };
    
    label.attributedText = [NSAttributedString.alloc initWithString:title attributes:attributes];
    
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
}

- (void)addReveal {
    SWRevealViewController *revealController = [self revealViewController];
    revealController.view.backgroundColor = UIColor.whiteColor;
    
    revealController.rearViewRevealWidth = 276.0f;
    revealController.rearViewRevealOverdraw = 0.0f;
    revealController.rearViewRevealDisplacement = 276.0f;
    
    revealController.frontViewShadowRadius = 0.0f;
    revealController.frontViewShadowColor = UIColor.clearColor;
    revealController.frontViewShadowOffset = CGSizeZero;
    
    revealController.toggleAnimationDuration = 0.21f;
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-nav-button"]
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

@end
