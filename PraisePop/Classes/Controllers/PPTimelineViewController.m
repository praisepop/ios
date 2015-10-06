//
//  PPTimelineViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPTimelineViewController.h"

#import "PPComposeViewController.h"

#import "PPPopTableViewCell.h"

static NSString *kPPPopCellIdentifier = @"PPPopCell";
static CGFloat kPPPopCellTextViewRatio = 0.7733f;

@interface PPTimelineViewController ()
@end

@implementation PPTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PRAISEPOP";
    
    [self initiateReveal];
    [self initiateButtons];
    
    UINib *popCell = [UINib nibWithNibName:@"PPPopCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:popCell forCellReuseIdentifier:kPPPopCellIdentifier];
}

- (void)initiateReveal {
    SWRevealViewController *revealController = [self revealViewController];
    
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

- (void)initiateButtons {
    UIBarButtonItem *composeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose-nav-button"]
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(revealComposer:)];
    
    self.navigationItem.rightBarButtonItem = composeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self heightForTextViewAtIndexPath:indexPath] <= 35) {
        return 120;
    }
    else {
        return [self heightForTextViewAtIndexPath:indexPath] + 85;
    }
}

- (CGFloat)heightForTextViewAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac sem ut nisi blandit porta. Etiam tincidunt euismod sapien, a tincidunt leo egestas at. Aenean id tincidunt mi, sed viverra urna. Donec bibendum justo nec dui rhoncus, id auctor risus consequat. Vestibulum mattis pharetra mauris eu posuere. Praesent sagittis rhoncus.!";
    
    NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:body attributes:[PPUnselectableTextView attributes]];
    CGFloat width = self.view.width * kPPPopCellTextViewRatio;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPPopTableViewCell *cell = (PPPopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPPPopCellIdentifier];
    
    cell.textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac sem ut nisi blandit porta. Etiam tincidunt euismod sapien, a tincidunt leo egestas at. Aenean id tincidunt mi, sed viverra urna. Donec bibendum justo nec dui rhoncus, id auctor risus consequat. Vestibulum mattis pharetra mauris eu posuere. Praesent sagittis rhoncus.";
    
    return cell;
}

- (void)revealComposer:(id)sender {
    PPComposeViewController *composer = (PPComposeViewController *)[PraisePop controllerWithIdentifier:@"PPComposeViewController"];
    
    [self.navigationController presentViewController:composer animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

@end
