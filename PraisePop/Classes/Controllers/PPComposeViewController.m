//
//  PPComposeViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPComposeViewController.h"
#import "PPComposeBar.h"

@interface PPComposeViewController () <UITextFieldDelegate, UITextViewDelegate, PPComposeBarDelegate>

@property (strong, nonatomic) IBOutlet UITextField *recipientField;
@property (strong, nonatomic) IBOutlet UITextView *postBody;

@property (strong, nonatomic) PPComposeBar *composeBar;

@end

@implementation PPComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeBar = [[[NSBundle mainBundle] loadNibNamed:@"PPComposerToolbar" owner:self options:nil] firstObject];
    self.composeBar.delegate = self;
    
    self.postBody.inputAccessoryView = self.composeBar;
    self.postBody.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int length = 500 - (int)(textView.text.length + text.length - range.length);
    
    self.composeBar.characterCounter.text = [NSString stringWithFormat:@"%i", length];
    return textView.text.length + (text.length - range.length) <= 500;
}

- (void)didSendPost {
    
}

- (void)didSelectPostType {
    
}

- (void)didCancelPost {
    [self pp_dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
