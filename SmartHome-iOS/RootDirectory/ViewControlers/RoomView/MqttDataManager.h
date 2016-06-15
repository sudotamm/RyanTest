//
//  MqttDataManager.h
//  SmartHome
//
//  Created by YuanRyan on 4/27/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MqttDataManager : NSObject<MQTTSessionDelegate>

@property (nonatomic, strong) MQTTSession *session;
@property (nonatomic, copy) void (^msgSendBlock)(BOOL msgSent);

+ (instancetype)sharedManager;

//MQTT connection methods
- (void)mqttConnect;
- (void)mqttDisconnect;

//MQTTClient request methods
//Sync methods
- (void)requestSubcribeTopic;
- (void)requestUploadConfigFile;
//Async methods
- (void)requestConfigFile;
- (void)requestDeviceList;
- (void)requestChangeDevice:(DeviceModel *)device
                   toStatus:(DeviceStatus)status
                    msgSent:(void (^)(BOOL msgSent))sendBlock;
@end
