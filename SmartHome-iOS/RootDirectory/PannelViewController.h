//
//  PannelViewController.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNaviViewController.h"

@interface PannelViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, weak) IBOutlet UIView *contentContainView;
@property (nonatomic, strong) RootNaviViewController *naviViewController;

@property (nonatomic, weak) IBOutlet UIView *hudView;
@property (nonatomic, weak) IBOutlet UILabel *hudLabel;


@end
