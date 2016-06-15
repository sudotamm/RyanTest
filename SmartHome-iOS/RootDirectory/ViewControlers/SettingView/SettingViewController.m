//
//  SettingViewController.m
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()


@end

@implementation SettingViewController

- (void)rightItemTapped
{
}

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"设置"];
    self.navigationItem.hidesBackButton = YES;
}
@end
