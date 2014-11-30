//
//  PropsDetailsViewController.m
//  iProps
//
//  Created by netguru on 30/11/14.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "PropsDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PropsDetailsViewController ()

@end

@implementation PropsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"%@", self.props);
    //self.propsTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //self.propsTextLabel.numberOfLines = 0;
    
    NSString *at = @"@";
    
    [self.usernameLabel setText:[at stringByAppendingString:_props.user.twitterUsername]];
    [self.fullnameLabel setText:_props.user.fullName];
    [self.propsTextLabel setText:_props.text];
    [self.avatarImage sd_setImageWithURL:_props.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"Awesome.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
