//
//  HomeModel.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.rooms = [NSMutableArray array];
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:@"rooms"])
            {
                NSArray *valueArray = [dict objectForKey:key];
                for(NSDictionary *dictRoom in valueArray)
                {
                    RoomModel *rm = [[RoomModel alloc] initWithRYDict:dictRoom];
                    [self.rooms addObject:rm];
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
    }
    return self;
}

@end
