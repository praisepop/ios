//
//  PPComposeViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPComposeViewController.h"
#import "PPComposeBar.h"

@interface PPComposeViewController () <UITextFieldDelegate, UITextViewDelegate, PPComposeBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *recipientField;
@property (strong, nonatomic) IBOutlet UITextView *postBody;

@property (strong, nonatomic) PPComposeBar *composeBar;
@property (strong, nonatomic) IBOutlet UIPickerView *postTypePicker;

@property (strong, nonatomic) NSDictionary *types;

@property (strong, nonatomic) NSString *postType;

@end

@implementation PPComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeBar = [[[NSBundle mainBundle] loadNibNamed:@"PPComposerToolbar" owner:self options:nil] firstObject];
    self.composeBar.delegate = self;
    
    self.postBody.inputAccessoryView = self.composeBar;
    self.postBody.delegate = self;
    
    self.types = @{
                   @"Announcement" : @"ANNOUNCEMENT",
                   @"Invitation" : @"INVITATION",
                   @"Shoutout" : @"SHOUTOUT"
                   };
    
    self.postTypePicker.delegate = self;
    self.postTypePicker.dataSource = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int length = 500 - (int)(textView.text.length + text.length - range.length);
    
    self.composeBar.characterCounter.text = [NSString stringWithFormat:@"%i", length];
    return textView.text.length + (text.length - range.length) <= 500;
}

- (void)didSendPost {
    
}

- (void)didSelectPostType {
    [self.postBody resignFirstResponder];
    self.postTypePicker.hidden = NO;
}

- (void)didCancelPost {
    [self pp_dismiss];
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.types.allKeys.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.types.allKeys[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.postType = self.types[self.types.allKeys[row]];
    [self.postTypePicker selectRow:row inComponent:0 animated:YES];
    [self.composeBar.typeButton setTitle:self.types.allKeys[row] forState:UIControlStateNormal];
    [self.postBody becomeFirstResponder];
    
    self.postTypePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
