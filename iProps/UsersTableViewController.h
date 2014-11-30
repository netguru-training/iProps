//
//  UsersTableViewController.h
//  iProps
//
//  Created by netguru on 29/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
- (IBAction)switchEditMode:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *labelSelectMultiple;
@property (weak, nonatomic) IBOutlet UIButton *buttonGiveMultipleProps;
- (IBAction)clickButtonSendMultipleProps:(id)sender;


@end
