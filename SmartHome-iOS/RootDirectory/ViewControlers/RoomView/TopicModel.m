//
//  TopicModel.m
//  SmartHome
//
//  Created by YuanRyan on 5/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (TopicType)type
{
    return (TopicType)(self.topicType.integerValue);
}

@end
