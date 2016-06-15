//
//  RoomDataManager.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "RoomModel.h"
#import "DeviceModel.h"

@interface RoomDataManager : NSObject

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) NSMutableArray *deviceArray;

+ (instancetype)sharedManager;

- (void)saveHomeData;
- (NSMutableArray *)availableArray;
- (DeviceModel *)deviceForAddress:(NSString *)address;
//维护房间的相关方法
- (void)addRoom:(RoomModel *)room inHome:(HomeModel *)homeModel;
- (void)deleteRoom:(RoomModel *)room inHome:(HomeModel *)homeModel;
- (void)updateHomeWithRoom:(RoomModel *)room;
//维护房间已经定制的设备状态的相关方法
- (void)addDevice:(DeviceModel *)changedDevice inRoom:(RoomModel *)room;
- (void)removeDevice:(DeviceModel *)changedDevice inRoom:(RoomModel *)room;
- (void)updateRoomWithDeviceModel:(DeviceModel *)changedDevice;
//维护可用列表设备状态的相关方法
- (void)addListWithDeviceModel:(DeviceModel *)changedDevice;
- (void)removeListWithDeviceModel:(DeviceModel *)changedDevice;
- (void)updateListWithDeviceModel:(DeviceModel *)changedDevice;

@end
