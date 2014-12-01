//
//  PropsTableViewController.m
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "PropsTableViewController.h"
#import "PropsDetailsViewController.h"
#import "TwitterRequest.h"
#import "TweetModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "ReachabilityManager.h"
#import <Reachability.h>
#import <TSMessage.h>

@interface PropsTableViewController ()

@end

@implementation PropsTableViewController {
    NSTimer* timerForTwitterConnection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    //NSLog(@"Internet: %d", [ReachabilityManager isReachable]);
    
    if ([ReachabilityManager isReachable]) {
        [self loadTweets];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ReachabilityManager sharedManager];
    [ReachabilityManager sharedManager].reachability.unreachableBlock = ^(Reachability *reachability){
        if (!reachability.isReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage showNotificationWithTitle:@"Connection error"
                                            subtitle:@"Your connection appears to be offline"
                                                type:TSMessageNotificationTypeError];
                
            });
        }
    };
}

- (void)loadTweets {
    timerForTwitterConnection = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleDataRefreshFailure:) userInfo:nil repeats:NO];
    [TwitterRequest loadTweetsWithHandler:^(NSArray *array) {
        self.data = array;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [timerForTwitterConnection invalidate];
            [self.tableView reloadData];
        });
    }];
}

- (void)handleDataRefreshFailure:(id)select {
    [self.refreshControl endRefreshing];
    [TSMessage showNotificationWithTitle:@"Connection error"
                                subtitle:@"Twitter appears to be lazy!"
                                    type:TSMessageNotificationTypeError];
    
}

- (void)refreshTable {
    [self loadTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"propsCell" forIndexPath:indexPath];
    
    if ([self.data count] > 0) {
        TweetModel *tweet = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = tweet.user.twitterUsername;
        cell.detailTextLabel.text = tweet.text;
        cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.borderWidth=1.5;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor=[[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
        [cell.imageView sd_setImageWithURL:tweet.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"Awesome.png"]];
    }
    return cell;
}

#pragma mark - segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPropsDetail"]) {
        PropsDetailsViewController* propsDetailsViewController = [segue destinationViewController];
        propsDetailsViewController.props = [self.data objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

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
