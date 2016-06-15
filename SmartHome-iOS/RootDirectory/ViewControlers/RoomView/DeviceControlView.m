//
//  DeviceControlView.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "DeviceControlView.h"

@interface DeviceControlView()

@property (nonatomic, strong) NSArray *onImagesArray;
@property (nonatomic, strong) UIImage *offImage;

@end

@implementation DeviceControlView

@synthesize deviceModel;

#pragma mark - Public methods
- (IBAction)ofOffButtonClicked:(id)sender
{
    DeviceStatus toStatus = kDeviceStatusOn;
    
    if(self.deviceModel.deviceStatus == kDeviceStatusOn)
        toStatus = kDeviceStatusOff;
    else
        toStatus = kDeviceStatusOn;
    
    self.onOffButton.enabled = NO;
    [[MqttDataManager sharedManager] requestChangeDevice:self.deviceModel
                                                toStatus:toStatus
                                                 msgSent:^(BOOL msgSent) {
                                                     self.onOffButton.enabled = YES;
                                                     if(msgSent)
                                                     {
                                                         self.deviceModel.deviceStatus = toStatus;
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
                                                     }
                                                     else
                                                     {
                                                         [SVProgressHUD showErrorWithStatus:kConnectingError];
                                                     }
        }];
}

- (void)reloadWithDeviceModel:(DeviceModel *)dm
{
    self.deviceModel = dm;
    [self reloadData];
}

- (void)reloadData
{
    NSString *statusStr = nil;
    if(self.deviceModel.deviceStatus == kDeviceStatusOn)
    {
        statusStr = @"已开启";
        self.onOffButton.enabled = YES;
        self.onOffButton.selected = YES;
        self.onOffImgView.image = nil;
        self.onOffImgView.animationImages = self.onImagesArray;
        self.onOffImgView.animationDuration = 0.3f;
        [self.onOffImgView startAnimating];
        
    }
    else if(self.deviceModel.deviceStatus == kDeviceStatusOff)
    {
        statusStr = @"已关闭";
        self.onOffButton.enabled = YES;
        self.onOffButton.selected = NO;
        self.onOffImgView.animationImages = nil;
        self.onOffImgView.image = self.offImage;
    }
    else
    {
        statusStr = @"已离线";
        self.onOffButton.enabled = NO;
        self.onOffButton.selected = NO;
        self.onOffImgView.animationImages = nil;
        self.onOffImgView.image = self.offImage;
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",self.deviceModel.name,statusStr];
}

//#pragma mark - Notification methods
//- (void)deviceChangedWithNotification:(NSNotification *)notification
//{
//    [self reloadData];
//}

#pragma mark - UIView methods

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceChangedWithNotification:) name:kRoomDeviceChangedNotification object:nil];
    
    self.offImage = [UIImage imageNamed:@"pic_off_3"];
    UIImage *onImg1 = [UIImage imageNamed:@"pic_on_1"];
    UIImage *onImg2 = [UIImage imageNamed:@"pic_on_2"];
    UIImage *onImg3 = [UIImage imageNamed:@"pic_on_3"];
    self.onImagesArray = [NSArray arrayWithObjects:onImg1,onImg2,onImg3, nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
