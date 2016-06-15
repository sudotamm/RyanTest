//
//  RootNaviViewController.m
//  RootDirectory
//
//  Created by ryan on 12/30/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RootNaviViewController.h"

@interface RootNaviViewController ()

@end

@implementation RootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *barImage = [UIImage imageNamed:@"pic_top_bg"];
    [self.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageNamed:@"pic_top-projection_bg"];
}

@end
