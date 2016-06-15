//
//  RoomViewController.h
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceListView.h"
#import "DeviceControlView.h"
#import "DeviceCollectionCell.h"
#import "NodataView.h"

@interface RoomViewController : BaseViewController<DeviceListViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, weak) IBOutlet UIView *rightView;
@property (nonatomic, weak) IBOutlet UIView *rightBottomView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightViewWConstraint;

@property (nonatomic, strong) DeviceListView *deviceListView;
@property (nonatomic, strong) DeviceControlView *deviceControlView;

@property (nonatomic, weak) IBOutlet UIView *tipView;
@property (nonatomic, strong) NodataView *nodataView;

@property (nonatomic, strong) RoomModel *roomModel;

- (IBAction)longPressedWithGesture:(UILongPressGestureRecognizer *)gesture;
@end
