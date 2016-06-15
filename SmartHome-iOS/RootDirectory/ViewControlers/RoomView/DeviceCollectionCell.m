//
//  DeviceCollectionCell.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "DeviceCollectionCell.h"

@implementation DeviceCollectionCell

- (IBAction)deleteButtonClicked:(id)sender
{
    if(self.deleteBlock)
        self.deleteBlock(self);
}

- (IBAction)editButtonClicked:(id)sender
{
    if(self.editBlock)
        self.editBlock(self);
}

- (void)reloadWithDeviceModel:(DeviceModel *)dm
                     selected:(BOOL)selected
                  deleteBlock:(DeviceDeleteBlock)db
                    editBlock:(DeviceEditBlock)eb
{
    self.deleteBlock = db;
    self.editBlock = eb;
    
    self.bgImgView.image = [UIImage imageNamed:@"bg_device"];
    if(dm.deviceType == kDeviceTypeUnkonw)
        self.nameLabel.text = kUnknownDeviceName;
    else
        self.nameLabel.text = dm.name;
    self.nameLabel.textColor = [UIColor colorWithRed:60.f/255 green:70.f/255 blue:75.f/255 alpha:1.f];
    NSMutableString *imageName = [NSMutableString string];

    if(dm.deviceType == kDeviceTypeSwitch)
    {
        [imageName appendString:@"icon_switch_"];
    }
    else if(dm.deviceType == kDeviceTypeSocket)
    {
        [imageName appendString:@"icon_socket_"];
    }
    else if(dm.deviceType == kDeviceTypeLight)
    {
        [imageName appendString:@"icon_light_"];
    }
    
    if(dm.deviceStatus == kDeviceStatusOn)
    {
        if(selected)
            [imageName appendString:@"pressed"];
        else
            [imageName appendString:@"on"];
        self.statusLabel.text = @"设备已开启";
        self.statusLabel.textColor = kOnColor;
    }
    else if(dm.deviceStatus == kDeviceStatusOff)
    {
        if(selected)
            [imageName appendString:@"pressed"];
        else
            [imageName appendString:@"off"];
        self.statusLabel.text = @"设备已关闭";
        self.statusLabel.textColor = kOffColor;
    }
    else
    {
        if(selected)
            [imageName appendString:@"pressed"];
        else
            [imageName appendString:@"offline"];
        self.statusLabel.text = @"设备已离线";
        self.statusLabel.textColor = kOffColor;
    }
    self.icnImgView.image = [UIImage imageNamed:imageName];
    if(selected)
    {
        self.nameLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textColor = [UIColor whiteColor];
        if(dm.deviceStatus == kDeviceStatusOn)
            self.bgImgView.image = [UIImage imageNamed:@"bg_service_selected"];
        else
            self.bgImgView.image = [UIImage imageNamed:@"bg_service_off_selected"];
    }
}

@end
