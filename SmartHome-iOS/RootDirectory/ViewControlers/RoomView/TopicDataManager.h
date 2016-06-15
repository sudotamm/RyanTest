//
//  TopicDataManager.h
//  SmartHome
//
//  Created by YuanRyan on 5/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicModel.h"

@interface TopicDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *topicArray;

+ (instancetype)sharedManager;


- (NSDictionary *)requestDictForTopic:(TopicType)type paramDict:(NSDictionary *)paramDict;
- (NSString *)requestStrForTopic:(TopicType)type paramDict:(NSDictionary *)paramDict;

- (NSString *)messageForTopic:(TopicType)type;
- (TopicType)typeForMessage:(NSString *)message topic:(NSString *)topic;
- (NSString *)topicNameForTopic:(TopicType)type;
@end
