//
//  PropsDetailsViewController.h
//  iProps
//
//  Created by netguru on 30/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface PropsDetailsViewController : UIViewController

@property (strong, nonatomic) TweetModel *props;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *propsTextLabel;

@end
