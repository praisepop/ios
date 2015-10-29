//
//  PPLogInViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/11/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPLogInViewController.h"

#import "PPTimelineViewController.h"

@interface PPLogInViewController () <UITextFieldDelegate, UIAlertViewDelegate>

/**
 *  The email field.
 */
@property (strong, nonatomic) IBOutlet UITextField *emailField;
/**
 *  The password field.  Secure text entry.
 */
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation PPLogInViewController 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self login:self.passwordField];
    }
    
    return YES;
}


- (IBAction)checkTextField:(id)sender {

}

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    
    if (self.emailField.text.length != 0 && self.passwordField.text.length != 0) {
        if ([self validEmail:self.emailField.text]) {
            [[PraisePopAPI sharedClient] login:self.emailField.text withPassword:self.passwordField.text success:^(BOOL result) {
                if (result) {
                    PPTimelineViewController *frontViewController = PPTimelineViewController.new;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                    
                    self.revealViewController.frontViewController = navigationController;
                    self.revealViewController.panGestureRecognizer.enabled = NO;
                }
                else {
                    UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"We were unable to log you in.  Please double check your credentials and internet connection.  Alternatively, make sure you've verified your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
            } failure:nil];
        }
        else {
            UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"Please make sure you've entered a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [UIAlertView.alloc initWithTitle:@"Oops!" message:@"Please fill out all fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
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

@end
