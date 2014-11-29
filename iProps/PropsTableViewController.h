//
//  PropsTableViewController.h
//  iProps
//
//  Created by Marek Buszman on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
