//
//  PPSignUpViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/11/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPSignUpViewController.h"

@interface PPSignUpViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation PPSignUpViewController

- (IBAction)popViewcontroller:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self.nameField becomeFirstResponder];
    }
    else {
        [self.view endEditing:YES];
    }
    
    return YES;
}


- (IBAction)checkTextField:(id)sender {
    
}

- (IBAction)signUp:(id)sender {
    if (self.emailField.text.length != 0 && self.passwordField.text.length != 0 && self.nameField.text.length != 0) {
        if ([self validEmail:self.emailField.text]) {
            if (![self blackListed:self.emailField.text]) {
                NSArray *nameParts = [self.nameField.text componentsSeparatedByString:@" "];
                if (nameParts.count >= 2) {
                    NSDictionary *name = @{
                                           @"first" : nameParts[0],
                                           @"last" : [self.nameField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",nameParts[0]] withString:@""]
                                           };
                    
                    [[PraisePopAPI sharedClient] signup:self.emailField.text password:self.passwordField.text name:name success:^(BOOL result) {
                        if (result) {
                            [self popViewcontroller:nil];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Please check your email to verify your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            
                            [alert show];
                        }
                        else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"We were unable to sign you up.  Please check your connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            
                            [alert show];
                        }
                    } failure:nil];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter both your first and last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    return;
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"The email you tried to use is blacklisted!  Please try another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please make sure you've entered a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please make sure you've put in valid inputs for all fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (BOOL)validEmail:(NSString *)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)blackListed:(NSString *)email {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"email-blacklist" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSString *domain = [[email componentsSeparatedByString:@"@"] lastObject];
    
    return [parsedData containsObject:domain];
}

@end
