//
//  TopicDataManager.m
//  SmartHome
//
//  Created by YuanRyan on 5/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "TopicDataManager.h"

@implementation TopicDataManager

#pragma mark - Singleton methods

- (id)init
{
    if(self = [super init])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MQTTTopic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        self.topicArray = [NSMutableArray array];
        for(NSDictionary *dictTopic in array)
        {
            TopicModel *tm = [[TopicModel alloc] initWithRYDict:dictTopic];
            [self.topicArray addObject:tm];
        }
    }
    return self;
}

+ (instancetype)sharedManager
{
    static TopicDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TopicDataManager alloc] init];
    });
    return manager;
}

#pragma mark - Public methods
- (NSString *)messageForTopic:(TopicType)type
{
    for(TopicModel *tmTemp in self.topicArray)
    {
        if(tmTemp.type == type)
            return tmTemp.topicMessage;
    }
    return nil;
}

- (TopicType)typeForMessage:(NSString *)message topic:(NSString *)topic
{
    for(TopicModel *tmTemp in self.topicArray)
    {
        if([tmTemp.topicMessage isEqualToString:message] && [tmTemp.topicName rangeOfString:topic].length > 0)
            return tmTemp.type;
    }
    return kTopicResponseDeviceUnknown;
}

- (NSString *)topicNameForTopic:(TopicType)type
{
    for(TopicModel *tmTemp in self.topicArray)
    {
        if(tmTemp.type == type)
            return tmTemp.topicName;
    }
    return nil;
}

- (NSDictionary *)requestDictForTopic:(TopicType)type paramDict:(NSDictionary *)paramDict
{
    NSString *message = [[TopicDataManager sharedManager] messageForTopic:type];
    if(nil == message)
        message = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if(type == kTopicRequestDeviceSetStatus)
    {
        [dict setObject:message forKey:@"message"];
        [dict setObject:paramDict forKey:@"device"];
    }
    else if(type == kTopicRequestDeviceListDevice)
    {
        [dict setObject:message forKey:@"message"];
    }
    else if(type == kTopicRequestDeviceConfigUpload)
    {
        [dict setObject:message forKey:@"message"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDict options:0 error:nil];
        NSString *configStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if(nil == configStr)
            configStr = @"";
        [dict setObject:configStr forKey:@"config"];
    }
    else if(type == kTopicRequestDeviceConfigfile)
    {

    }
    return dict;
}

- (NSString *)requestStrForTopic:(TopicType)type paramDict:(NSDictionary *)paramDict
{
    NSDictionary *dict = [self requestDictForTopic:type paramDict:paramDict];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if(nil == str)
        str = @"";
    return str;
}
@end
