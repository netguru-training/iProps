//
//  PropsTableViewController.m
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "PropsTableViewController.h"
#import "TwitterRequest.h"
#import "TweetModel.h"

@interface PropsTableViewController ()
@property (strong, nonatomic) NSArray *users;
@end

@implementation PropsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.data = [[NSMutableArray alloc] init];
    [TwitterRequest loadTweetsWithHandler:^(NSData *data, NSHTTPURLResponse *responseUrl, NSError *error) {
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for (NSDictionary *user_data in parsedObject[@"statuses"]) {
            [self.data addObject:[MTLJSONAdapter modelOfClass:[TweetModel class] fromJSONDictionary:user_data error:nil]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTable];
        });
    }];
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
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
    if ([self.data count] > 0) {
        return [self.data count];
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"propsCell" forIndexPath:indexPath];
    
    if ([self.data count] > 0) {
        TweetModel *tweet = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = tweet.user.twitterUsername;
        cell.detailTextLabel.text = tweet.text;
    } else {
        cell.textLabel.text = @"Loading";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
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
