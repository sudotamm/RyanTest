//
//  DeviceTableCell.m
//  SmartHome
//
//  Created by YuanRyan on 5/5/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "DeviceTableCell.h"

@implementation DeviceTableCell

- (void)reloadWithDeviceModel:(DeviceModel *)dm
{
    if(dm.deviceType == kDeviceTypeUnkonw)
        self.nameLabel.text = kUnknownDeviceName;
    else
        self.nameLabel.text = dm.name;
    NSMutableString *imageName = [NSMutableString string];
    
    if(dm.deviceType == kDeviceTypeSwitch)
    {
        [imageName appendString:@"ls_icon_switch_"];
    }
    else if(dm.deviceType == kDeviceTypeSocket)
    {
        [imageName appendString:@"ls_icon_socket_"];
    }
    else if(dm.deviceType == kDeviceTypeLight)
    {
        [imageName appendString:@"ls_icon_light_"];
    }
    
    if(dm.deviceStatus == kDeviceStatusOn)
    {
        [imageName appendString:@"on"];
        self.statusLabel.text = @"设备已开启";
        self.statusLabel.textColor = kOnColor;
    }
    else if(dm.deviceStatus == kDeviceStatusOff)
    {
        [imageName appendString:@"off"];
        self.statusLabel.text = @"设备已关闭";
        self.statusLabel.textColor = kOffColor;
    }
    else
    {
        [imageName appendString:@"offline"];
        self.statusLabel.text = @"设备已离线";
        self.statusLabel.textColor = kOffColor;
    }
    self.icnImgView.image = [UIImage imageNamed:imageName];
}
@end
