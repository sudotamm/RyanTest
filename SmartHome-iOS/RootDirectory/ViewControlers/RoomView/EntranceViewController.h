//
//  EntranceViewController.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "NodataView.h"

@interface EntranceViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UIView *tipView;
@property (nonatomic, strong) NodataView *nodataView;

@end
