//
//  TopicModel.h
//  SmartHome
//
//  Created by YuanRyan on 5/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TopicType) {
    kTopicResponseDeviceUnknown = 0,
    kTopicResponseDeviceAdded = 1,
    kTopicResponseDeviceRemoved = 2,
    kTopicResponseDeviceChanged = 3,
    kTopicRequestDeviceSetStatus = 4,
    kTopicRequestDeviceListDevice = 5,
    kTopicResponseDeviceListDevice = 6,
    kTopicRequestDeviceConfigUpload = 7,
    kTopicRequestDeviceConfigfile = 8,
    kTopicResponseDeviceConfigfile = 9
};

@interface TopicModel : RYBaseModel

@property (nonatomic, copy) NSString *topicType;
@property (nonatomic, copy) NSString *topicName;
@property (nonatomic, copy) NSString *topicMessage;

@property (nonatomic, assign) TopicType type;

@end
