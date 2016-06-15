//
//  MqttDataManager.m
//  SmartHome
//
//  Created by YuanRyan on 4/27/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "MqttDataManager.h"

@interface MqttDataManager()

@property (nonatomic, assign) NSInteger messageId;

@end

@implementation MqttDataManager

#pragma mark - Singleton methods
- (id)init
{
    if(self = [super init])
    {
        MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
        transport.host = kMQTTServerHost;
        transport.port = kMQTTServerPort;
        
        self.session = [[MQTTSession alloc] init];
        self.session.keepAliveInterval = 60;
        self.session.clientId = [[UIDevice currentDevice] RYUDID];
//        self.session.userName = @"Ryan";
//        self.session.password = @"Ryan";
        self.session.cleanSessionFlag = 0;
//        self.session.protocolLevel = MQTTProtocolVersion311;
        self.session.transport = transport;
        self.session.delegate=self;
    }
    return self;
}

+ (instancetype)sharedManager
{
    static MqttDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MqttDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [self mqttDisconnect];
}

#pragma mark - Private methods
- (NSInteger)publishData:(NSString *)str topic:(NSString *)topic atLevel:(MQTTQosLevel)level
{
    if(self.session.status != MQTTSessionStatusConnected)
        return 0;
    
    NSData *pushData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //asynchronous api
    NSInteger pushMsgId = [self.session publishData:pushData onTopic:topic retain:NO qos:level];
    NSLog(@"publish message: %@", @(pushMsgId));
    return pushMsgId;
}

- (BOOL)publishSynData:(NSString *)str topic:(NSString *)topic atLevel:(MQTTQosLevel)level
{
    if(self.session.status != MQTTSessionStatusConnected)
        return NO;
    
    NSData *pushData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //asynchronous api
    return [self.session publishAndWaitData:pushData onTopic:topic retain:NO qos:level];
}

#pragma mark - Public methods

- (void)requestChangeDevice:(DeviceModel *)device
                   toStatus:(DeviceStatus)status
                    msgSent:(void (^)(BOOL msgSent))sendBlock
{
    self.msgSendBlock = sendBlock;
    if(self.session.status != MQTTSessionStatusConnected)
    {
        self.msgSendBlock(NO);
        return;
    }
    if(status == kDeviceStatusOffline)
        return;
    NSMutableDictionary *deviceDict = [device toDict];

    if(status == kDeviceStatusOn)
    {
        [deviceDict setObject:@"On" forKey:@"status"];
    }
    else
    {
        [deviceDict setObject:@"Off" forKey:@"status"];
    }
    //异步请求更改设备状态
    NSString *listTopic = [NSString stringWithFormat:@"%@%@",kHubAddress, [[TopicDataManager sharedManager] topicNameForTopic:kTopicRequestDeviceSetStatus]];
    NSString *requestListStr = [[TopicDataManager sharedManager] requestStrForTopic:kTopicRequestDeviceSetStatus paramDict:deviceDict];
    NSInteger pushMsgId = [self publishData:requestListStr topic:listTopic atLevel:MQTTQosLevelExactlyOnce];
    self.messageId = pushMsgId;
    if(pushMsgId == 0)
    {
        self.msgSendBlock(NO);
    }
}
- (void)requestDeviceList
{
    if(self.session.status != MQTTSessionStatusConnected)
        return;
    
    //异步请求获取可用设备列表
    NSString *listTopic = [NSString stringWithFormat:@"%@%@",kHubAddress, [[TopicDataManager sharedManager] topicNameForTopic:kTopicRequestDeviceListDevice]];
    NSString *requestListStr = [[TopicDataManager sharedManager] requestStrForTopic:kTopicRequestDeviceListDevice paramDict:nil];
    [self publishData:requestListStr topic:listTopic atLevel:MQTTQosLevelExactlyOnce];
}

- (void)requestConfigFile
{
    if(self.session.status != MQTTSessionStatusConnected)
        return;
    //同步请求获取config file
    NSString *configTopic = [NSString stringWithFormat:@"%@%@",kHubAddress, [[TopicDataManager sharedManager] topicNameForTopic:kTopicRequestDeviceConfigfile]];
    NSString *requestStr = [[TopicDataManager sharedManager] requestStrForTopic:kTopicRequestDeviceConfigfile paramDict:nil];
    [self publishData:requestStr topic:configTopic atLevel:MQTTQosLevelExactlyOnce];
}

- (void)requestSubcribeTopic
{
    if(self.session.status != MQTTSessionStatusConnected)
        return;
    //同步请求订阅respnse主题
    NSString *subscribeTopic = [NSString stringWithFormat:@"%@%@",kHubAddress, [[TopicDataManager sharedManager] topicNameForTopic:kTopicResponseDeviceAdded]];
    //synchronous api - 订阅hub消息
    
    if([self.session subscribeAndWaitToTopic:subscribeTopic atLevel:MQTTQosLevelExactlyOnce])
    {
        NSLog(@"MQTTClient: subscribe succeed.");
    }
}

- (void)requestUploadConfigFile
{
    if(self.session.status != MQTTSessionStatusConnected)
        return;
    //同步请求上传config file
    NSString *configTopic = [NSString stringWithFormat:@"%@%@",kHubAddress, [[TopicDataManager sharedManager] topicNameForTopic:kTopicRequestDeviceConfigUpload]];
    NSDictionary *homeDict = [NSDictionary dictionaryWithObject:[[RoomDataManager sharedManager].home toDict] forKey:@"home"];
    
    NSString *requestStr = [[TopicDataManager sharedManager] requestStrForTopic:kTopicRequestDeviceConfigUpload paramDict:homeDict];
    
    BOOL isUploaded = [[MqttDataManager sharedManager] publishSynData:requestStr topic:configTopic atLevel:MQTTQosLevelExactlyOnce];
    if(isUploaded)
        NSLog(@"MQTTClient: upload config file succeed.");
    else
        NSLog(@"MQTTClient: upload config file failed.");
}

- (void)showHud
{
    [JDStatusBarNotification showWithStatus:kConnectingServer styleName:JDStatusBarStyleDark];
    [JDStatusBarNotification showActivityIndicator:YES
                                    indicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)mqttConnect
{
    [self performSelector:@selector(showHud) withObject:nil afterDelay:0];
    
    if(self.session.status < MQTTSessionStatusConnecting || self.session.status > MQTTSessionStatusConnected)
    {
        [self.session connect];
    }
}

- (void)mqttDisconnect
{
    [self.session close];
}

#pragma mark - MQTTSessionDelegate methods
- (void)connected:(MQTTSession *)session
{
    NSLog(@"MQTTClient: connection succeed.");
    [JDStatusBarNotification showWithStatus:kConnectSucceed dismissAfter:2.f styleName:JDStatusBarStyleSuccess];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestSubcribeTopic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestConfigFile];
        });
    });
}

- (void)connectionClosed:(MQTTSession *)session
{
    NSLog(@"MQTTClient: connection closed.");
    [JDStatusBarNotification showWithStatus:kConnectingClosed styleName:JDStatusBarStyleError];
}

- (void)connectionError:(MQTTSession *)session error:(NSError *)error
{
    NSLog(@"MQTTClient: connection error.");
    [JDStatusBarNotification showWithStatus:kConnectingError styleName:JDStatusBarStyleError];

}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    // this is one of the delegate callbacks
    NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MQTTClient: receive message: %@",responseStr);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *message = [dict objectForKey:@"message"];
    TopicType topicType = [[TopicDataManager sharedManager] typeForMessage:message topic:@"response"];
    switch (topicType) {
        case kTopicResponseDeviceAdded:
        {
            NSDictionary *dictDevice = [dict objectForKey:@"device"];
            DeviceModel *dm = [[DeviceModel alloc] initWithRYDict:dictDevice];
            if(dm.deviceType == kDeviceTypeUnkonw)
                break;
            [[RoomDataManager sharedManager] addListWithDeviceModel:dm];
            [[RoomDataManager sharedManager] addDevice:dm inRoom:nil];
        }
            break;
        case kTopicResponseDeviceRemoved:
        {
            NSDictionary *dictDevice = [dict objectForKey:@"device"];
            DeviceModel *dm = [[DeviceModel alloc] initWithRYDict:dictDevice];
            if(dm.deviceType == kDeviceTypeUnkonw)
                break;
            [[RoomDataManager sharedManager] removeListWithDeviceModel:dm];
            [[RoomDataManager sharedManager] removeDevice:dm inRoom:nil];
        }
            break;
        case kTopicResponseDeviceChanged:
        {
            NSDictionary *dictDevice = [dict objectForKey:@"device"];
            DeviceModel *dm = [[DeviceModel alloc] initWithRYDict:dictDevice];
            if(dm.deviceType == kDeviceTypeUnkonw)
                break;
            [[RoomDataManager sharedManager] updateListWithDeviceModel:dm];
            [[RoomDataManager sharedManager] updateRoomWithDeviceModel:dm];
        }
            break;
        case kTopicResponseDeviceListDevice:
        {
            [RoomDataManager sharedManager].deviceArray = [NSMutableArray array];
            
            NSArray *devicesArray = [dict objectForKey:@"devices"];
            for(NSDictionary *dictDevice in devicesArray)
            {
                DeviceModel *dm  = [[DeviceModel alloc] initWithRYDict:dictDevice];
                if(dm.deviceType == kDeviceTypeUnkonw)
                    continue;
                [[RoomDataManager sharedManager].deviceArray addObject:dm];
                [[RoomDataManager sharedManager] updateRoomWithDeviceModel:dm];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
        }
            break;
        case kTopicResponseDeviceConfigfile:
        {
            NSString *configStr = [dict objectForKey:@"config"];
            NSData *jsonData = [configStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            NSDictionary *homeDict = [configDict objectForKey:@"home"];
            [RoomDataManager sharedManager].home = [[HomeModel alloc] initWithRYDict:homeDict];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowEntranceViewNotification object:nil];
            //asynchronous api - request device list
            [self requestDeviceList];
        }
            break;
        default:
        {
            NSLog(@"unknow message type: %@", message);
        }
            break;
    }
    
}

- (void)messageDelivered:(MQTTSession *)session msgID:(UInt16)msgID
{
    if(msgID == self.messageId)
    {
        if(self.msgSendBlock)
        {
            self.msgSendBlock(YES);
        }
    }
}
@end
