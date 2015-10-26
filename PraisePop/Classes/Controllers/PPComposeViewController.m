//
//  PPComposeViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPComposeViewController.h"
#import "PPComposeBar.h"
#import "PPPost.h"

#import "TwitterText.h"

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
    
    self.postType = @"UNCATEGORIZED";
    
    self.postBody.inputAccessoryView = self.composeBar;
    self.recipientField.inputAccessoryView = self.composeBar;
    self.postBody.delegate = self;
    
    self.types = @{
                   @"Announcement" : @"ANNOUNCEMENT",
                   @"Invite" : @"INVITE",
                   @"Shoutout" : @"SHOUTOUT",
                   @"Uncategorized" : @"UNCATEGORIZED"
                   };
    
    self.postTypePicker.delegate = self;
    self.postTypePicker.dataSource = self;
    
    [self.postBody becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int length = 500 - (int)(textView.text.length + text.length - range.length);
    
    self.composeBar.characterCounter.text = [NSString stringWithFormat:@"%i", length];
    return textView.text.length + (text.length - range.length) <= 500;
}

- (void)didSendPost {
    if (self.postBody.text.length != 0 && self.postBody.text.length != 0) {
        NSArray *nameParts = [self.recipientField.text componentsSeparatedByString:@" "];
        if (nameParts.count >= 2) {
            NSDictionary *name = @{
                                   @"first" : nameParts[0],
                                   @"last" : [self.recipientField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",nameParts[0]] withString:@""]
                                   };
            
            NSArray *hashtags = [TwitterText hashtagsInText:self.postBody.text checkingURLOverlap:NO];
            
            NSMutableArray *rawHashtags = [@[] mutableCopy];
            
            for (TwitterTextEntity *entity in hashtags) {
                [rawHashtags addObject:[self.postBody.text substringWithRange:entity.range]];
            }
            
            [[PraisePopAPI sharedClient] send:self.postBody.text type:self.postType recepient:name hashtags:rawHashtags success:^(BOOL result) {
                if (result) {
                    [self pp_dismiss];
                    
                    
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didPost)]) {
                        [self.delegate didPost];
                    }
                }
                else {
                    UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"We were unable to post your post... please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            } failure:nil];
        }
        else {
            UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"Please enter a valid name!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"Please fill out all of the fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didSelectPostType {
    [self.postBody resignFirstResponder];
    self.postTypePicker.hidden = NO;
}

- (void)didCancelPost {
    [self pp_dismiss];
}

#pragma mark PickerView DataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

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
