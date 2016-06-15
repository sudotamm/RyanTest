//
//  DeviceModel.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

typedef NS_ENUM(NSInteger, DeviceType) {
    kDeviceTypeUnkonw = 0,
    kDeviceTypeSwitch,
    kDeviceTypeSocket,
    kDeviceTypeLight
};

typedef NS_ENUM(NSInteger, DeviceStatus) {
    kDeviceStatusOffline = 0,
    kDeviceStatusOn,
    kDeviceStatusOff
};

@interface DeviceModel : RYBaseModel

@property (nonatomic, copy) NSString *name;     //设备名称
@property (nonatomic, copy) NSString *address;  //设备号地址
@property (nonatomic, copy) NSString *type;     //设备类型
@property (nonatomic, copy) NSString *status;   //设备状态

@property (nonatomic, assign) DeviceType deviceType;
@property (nonatomic, assign) DeviceStatus deviceStatus;

- (void)updateWithDeviceModel:(DeviceModel *)changedDevice;

@end
