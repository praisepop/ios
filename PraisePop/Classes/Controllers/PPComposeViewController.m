//
//  PPComposeViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "TwitterText.h"
#import "PPPost.h"

#import "PPComposeBar.h"

#import "PPComposeViewController.h"

@interface PPComposeViewController () <UITextFieldDelegate, UITextViewDelegate, PPComposeBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  The recipient field.
 */
@property (strong, nonatomic) IBOutlet UITextField *recipientField;

/**
 *  The postBody text view;
 */
@property (strong, nonatomic) IBOutlet UITextView *postBody;

/**
 *  The post type picker.
 */
@property (strong, nonatomic) IBOutlet UIPickerView *postTypePicker;

/**
 *  The post type.
 */
@property (nonatomic) PPPostType postType;

/**
 *  The input accessory toolbar.
 */
@property (strong, nonatomic) PPComposeBar *composeBar;

@end

@implementation PPComposeViewController

/**
 *  Converts a PPPostType into a string.
 *
 *  @param postType The post type.
 *
 *  @return The resulting string.
 */
NSString * NSStringFromPPPostType(PPPostType postType) {
    switch (postType) {
        case PPPostShoutout:
            return @"SHOUTOUT";
            break;
        case PPPostInvite:
            return @"INVITE";
            break;
        case PPPostAnnouncement:
            return @"ANNOUNCEMENT";
            break;
            
        default:
            return @"UNCATEGORIZED";
            break;
    }
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeBar = [[[NSBundle mainBundle] loadNibNamed:@"PPComposerToolbar" owner:self options:nil] firstObject];
    self.composeBar.delegate = self;
    
    self.postType = PPPostUncategorized;
    
    self.postBody.inputAccessoryView = self.composeBar;
    
    self.recipientField.inputAccessoryView = self.composeBar;
    
    self.postTypePicker.delegate = self;
    self.postTypePicker.dataSource = self;
    
    [self.recipientField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSDictionary *)types {
    return @{
             @"Uncategorized" : @"UNCATEGORIZED",
             @"Shoutout" : @"SHOUTOUT",
             @"Invite" : @"INVITE",
             @"Announcement" : @"ANNOUNCEMENT"
             };
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    int length = 500 - (int)(textView.text.length + text.length - range.length);
    self.composeBar.characterCounter.text = [NSString stringWithFormat:@"%i", length];
    
    return textView.text.length + (text.length - range.length) <= 500;
}

- (void)didSendPost {
    if (self.postBody.text.length != 0 && self.postBody.text.length != 0) {
        NSArray *nameParts = [self.recipientField.text componentsSeparatedByString:@" "];
        
        NSString *recipient = [self.recipientField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([recipient.lowercaseString isEqualToString:@"everyone"] || nameParts.count >= 2) {
            NSMutableDictionary *name = [@{
                                   @"first" : nameParts[0],
                                   @"last" : [self.recipientField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",nameParts[0]] withString:@""]
                                   } mutableCopy];
            
            if ([recipient.lowercaseString isEqualToString:@"everyone"]) {
                name[@"last"] = @"";
            }
            
            NSLog(@"name");
            
            NSArray *hashtags = [TwitterText hashtagsInText:self.postBody.text checkingURLOverlap:NO];
            
            NSMutableArray *rawHashtags = [@[] mutableCopy];
            
            for (TwitterTextEntity *entity in hashtags) {
                [rawHashtags addObject:[self.postBody.text substringWithRange:entity.range]];
            }
            
            [[PraisePopAPI sharedClient] send:self.postBody.text type:NSStringFromPPPostType(self.postType) recepient:name hashtags:rawHashtags success:^(BOOL result) {
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
    [self.view endEditing:YES];
    self.postTypePicker.hidden = NO;
}

- (void)didCancelPost {
    [self pp_dismiss];
}

#pragma mark PickerView Delegate

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
    self.postType = row;
    [self.postTypePicker selectRow:row inComponent:0 animated:YES];
    [self.composeBar.typeButton setTitle:self.types.allKeys[row] forState:UIControlStateNormal];
    [self.postBody becomeFirstResponder];
    
    self.postTypePicker.hidden = YES;
}

@end
