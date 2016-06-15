//
//  RoomModel.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RoomModel.h"

@implementation RoomModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.devices = [NSMutableArray array];
        self.roomId = [RYCommonMethods generateUniqueString];
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:@"devices"])
            {
                NSArray *valueArray = [dict objectForKey:key];
                for(NSDictionary *dictDevice in valueArray)
                {
                    DeviceModel *dm = [[DeviceModel alloc] initWithRYDict:dictDevice];
                    [self.devices addObject:dm];
                }
                continue;
            }
            
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
        //默认房间名称
        if(self.name.length == 0)
        {
            self.name = kDefaultRoomName;
        }
    }
    return self;
}

- (void)updateWithRoomModel:(RoomModel *)changedRoom
{
    self.roomId = changedRoom.roomId;
    self.name = changedRoom.name;
    self.devices = changedRoom.devices;
}
@end
