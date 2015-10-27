//
//  UIViewController+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UIViewController+PPExtensions.h"

@implementation UIViewController (PPExtensions)

- (void)pp_setTitle:(NSString *)title {
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

- (void)pp_dismiss {
    [self dismissViewController:nil];
}

- (void)dismissViewController:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
