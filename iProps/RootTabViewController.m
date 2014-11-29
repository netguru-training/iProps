//
//  RootTabViewController.m
//  iProps
//
//  Created by Michał Kaźmierczak on 29.11.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "RootTabViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)awakeFromNib {
    UINavigationController *nVC = [[UIStoryboard storyboardWithName:@"PropsViewController" bundle:nil] instantiateInitialViewController];
    nVC.title = @"Props";
    
    [self setViewControllers:@[nVC]];
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
