//
//  RYBaseModel+ParseToJson.m
//  SmartHome
//
//  Created by YuanRyan on 5/16/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYBaseModel+ParseToJson.h"
#import <objc/runtime.h>

@implementation RYBaseModel (ParseToJson)

- (NSMutableDictionary *)toDict
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if ([propertyValue isKindOfClass:[NSArray class]])
        {
            NSMutableArray *dictArray = [NSMutableArray array];
            NSArray *valueArray = (NSArray *)propertyValue;
            for(id valueObj in valueArray)
            {
                if([valueObj isKindOfClass:[RYBaseModel class]])
                {
                    RYBaseModel *bm = (RYBaseModel *)valueObj;
                    NSMutableDictionary *objDict = [bm toDict];
                    [dictArray addObject:objDict];
                }
            }
            [props setObject:dictArray forKey:propertyName];
        }
        else
        {
            if(nil == propertyValue)
                propertyValue = @"";
            if([self isKindOfClass:[DeviceModel class]] && ([propertyName isEqualToString:@"deviceType"] || [propertyName isEqualToString:@"deviceStatus"]))
                continue;
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

@end
