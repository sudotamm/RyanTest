//
//  DeviceModel.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"id"]) {
                key = @"idTemp";
            }
            if([value isKindOfClass:[NSNumber class]])
                value = [NSString stringWithFormat:@"%@",value];
            else if([value isKindOfClass:[NSNull class]])
                value = @"";
            @try {
                [self setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"试图添加不存在的key:%@到实例:%@中.",key,NSStringFromClass([self class]));
            }
        }
        //默认设备名称
        if(self.name.length == 0)
        {
            self.name = kDefaultDeviceName;
        }
    }
    return self;
}

- (DeviceType)deviceType
{
    if([self.type.lowercaseString isEqualToString:@"Switch".lowercaseString])
        return kDeviceTypeSwitch;
    else if([self.type.lowercaseString isEqualToString:@"Socket".lowercaseString])
        return kDeviceTypeSocket;
    else if([self.type.lowercaseString isEqualToString:@"Light".lowercaseString])
        return kDeviceTypeLight;
    else
        return kDeviceTypeUnkonw;
}

- (DeviceStatus)deviceStatus
{
    if([self.status.lowercaseString isEqualToString:@"On".lowercaseString])
        return kDeviceStatusOn;
    else if([self.status.lowercaseString isEqualToString:@"Off".lowercaseString])
        return kDeviceStatusOff;
    else
        return kDeviceStatusOffline;
}

- (void)setDeviceStatus:(DeviceStatus)ds
{
    if(ds == kDeviceStatusOn)
        self.status = @"On";
    else if(ds == kDeviceStatusOff)
        self.status = @"Off";
    else
        self.status = @"";
}

- (void)updateWithDeviceModel:(DeviceModel *)changedDevice
{
    self.type = changedDevice.type;
    self.address = changedDevice.address;
    self.status = changedDevice.status;
}
@end
