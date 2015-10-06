//
//  UIViewController+PPExtensions.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/5/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "UIViewController+PPExtensions.h"

@implementation UIViewController (PPExtensions)

- (void)setTitle:(NSString *)title {
    UILabel *label = [UILabel.alloc initWithFrame:self.navigationItem.titleView.frame];
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont pp_fontWithName:FuturaBold size:25.0],
                                 NSKernAttributeName: @3
                                 };
    
    label.attributedText = [NSAttributedString.alloc initWithString:@"PRAISEPOP" attributes:attributes];
    
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
//    UIImage *navBarImage = [UIImage imageNamed:@"logo-nav-bar"];
//    UIImageView *titleImageView = [UIImageView.alloc initWithImage:navBarImage];
//    titleImageView.frame = CGRectMake(titleImageView.x, titleImageView.y, 172.5f, 20.5f);
//    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewController:sender];
}

- (void)dismissViewController:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
