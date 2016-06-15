//
//  DeviceListView.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceListViewDelegate;

@interface DeviceListView : UIView

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, assign) id<DeviceListViewDelegate> delegate;

- (void)reloadData;

@end

@protocol DeviceListViewDelegate <NSObject>

- (void)didAddDeviceWithListView:(DeviceListView *)listView device:(DeviceModel *)dm;

@end