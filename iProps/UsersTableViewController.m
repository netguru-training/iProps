//
//  UsersTableViewController.m
//  iProps
//
//  Created by netguru on 29/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "UsersTableViewController.h"
#import "TwitterRequest.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
@import Social;

@interface UsersTableViewController ()
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) NSArray *data;
    @property (strong, nonatomic) NSArray *searchResults;
@end


@implementation UsersTableViewController {
    NSMutableDictionary* selectedUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedUsers = [[NSMutableDictionary alloc] init];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    
    [self.refreshControl beginRefreshing];
    
    [TwitterRequest loadUsersOnComplete:^(NSArray *users) {
        if ([users count] > 0) {
            self.data = users;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)refreshTable {
    [selectedUsers removeAllObjects];
    [TwitterRequest loadUsersOnComplete:^(NSArray *users) {
        if ([users count] > 0) {
            self.data = users;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
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
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [self.searchResults count];
        } else {
            return [self.data count];
        }
        return [self.data count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];

    if ([self.data count] > 0) {

        UserModel *user;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            user = self.searchResults[indexPath.row];
        } else {
            user = self.data[indexPath.row];
        }

        cell.detailTextLabel.text = user.fullName;
        cell.textLabel.text = user.twitterUsername;
        cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.borderWidth=1.5;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor=[[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
        [cell.imageView sd_setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"Awesome.png"]];
    }
    
    if (self.tableView.isEditing) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UserModel *user;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            user = self.searchResults[indexPath.row];
        } else {
            user = self.data[indexPath.row];
        }

        cell.detailTextLabel.text = user.fullName;
        cell.textLabel.text = user.twitterUsername;
        cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.borderWidth=1.5;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor=[[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
        [cell.imageView sd_setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"Awesome.png"]];

    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchResults = [self.data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"twitterUsername contains[cd] %@", searchString]];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UserModel *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = self.searchResults[indexPath.row];
    } else {
        user = self.data[indexPath.row];
    }
    
    if ([cell isEditing] == YES) {
        [selectedUsers setObject:user.twitterUsername forKey:user.twitterUsername];
    } else {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *composeController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [composeController setInitialText:[NSString stringWithFormat:@"#ngprops dla %@", user.twitterUsername]];
            
            [self presentViewController:composeController
                               animated:YES completion:nil];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = self.searchResults[indexPath.row];
    } else {
        user = self.data[indexPath.row];
    }
    [selectedUsers removeObjectForKey:user.twitterUsername];
}

- (void)viewDidAppear:(BOOL)animated{
//self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
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

#pragma mark - Editing

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}

- (IBAction)switchEditMode:(id)sender {
    [selectedUsers removeAllObjects];
    [self.tableView setEditing:![self.tableView isEditing]];
    if([self.tableView isEditing]) {
        [self.labelSelectMultiple setTitle:@"Cancel"];
        [self.buttonGiveMultipleProps setHidden:NO];
    }
    else {
        [self.labelSelectMultiple setTitle:@"Select multiple"];
        [self.buttonGiveMultipleProps setHidden:YES];
    }
    [self.tableView reloadData]; // force reload to reset selection style
}
- (IBAction)clickButtonSendMultipleProps:(id)sender {
    //NSLog(@"%@", selectedUsers);
    
    NSString* mentions = @"#ngprops dla ";
    
    for (NSString* key in selectedUsers) {
        mentions = [mentions stringByAppendingString:@"@"];
        mentions = [mentions stringByAppendingString:key];
        mentions = [mentions stringByAppendingString:@" "];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:mentions];
        
        [self presentViewController:composeController
                           animated:YES completion:nil];
    }
}

@end
