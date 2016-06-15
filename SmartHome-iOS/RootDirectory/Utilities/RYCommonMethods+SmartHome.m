//
//  RYCommonMethods+SmartHome.m
//  SmartHome
//
//  Created by YuanRyan on 5/24/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYCommonMethods+SmartHome.h"

@implementation RYCommonMethods (SmartHome)

+ (BOOL)isValidateString:(NSString *)validString
{
    if(validString.length == 0)
        return NO;
    NSString *validRegex = @"\\w{0,8}";
    NSPredicate *validTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",validRegex];
    return [validTest evaluateWithObject:validString];
}

@end
