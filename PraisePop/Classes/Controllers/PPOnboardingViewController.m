//
//  PPOnboardingViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPOnboardingViewController.h"

#import "PPLogInViewController.h"
#import "PPSignUpViewController.h"

@interface PPOnboardingViewController ()

@end

@implementation PPOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    // login tag == 0
    // sign in tag == 1
    
    if (button.tag == 0) {
        PPLogInViewController *loginController = (PPLogInViewController *)[UIStoryboard pp_controllerWithIdentifier:@"PPLogInViewController"];
        [self.navigationController pushViewController:loginController animated:YES];
    }
    else {
        PPSignUpViewController *signupController = (PPSignUpViewController *)[UIStoryboard pp_controllerWithIdentifier:@"PPSignUpViewController"];
        [self.navigationController pushViewController:signupController animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
