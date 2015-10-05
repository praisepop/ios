//
//  PPTimelineViewController.m
//  PraisePop
//
//  Created by Rudd Fawcett on 10/4/15.
//  Copyright © 2015 PraisePop. All rights reserved.
//

#import "PPTimelineViewController.h"

@interface PPTimelineViewController ()

@end

@implementation PPTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initiateTitleView];
    [self initiateReveal];
    [self initiateButtons];
}

- (void)initiateTitleView {
    UIImage *navBarImage = [UIImage imageNamed:@"logo-nav-bar"];
    UIImageView *titleImageView = [UIImageView.alloc initWithImage:navBarImage];
    titleImageView.frame = CGRectMake(titleImageView.x, titleImageView.y, 172.5f, 20.5f);
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = titleImageView;
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
                                                                        style:UIBarButtonItemStyleDone target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = composeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
