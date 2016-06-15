//
//  RYCommonMethods+SmartHome.h
//  SmartHome
//
//  Created by YuanRyan on 5/24/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <RYUtils/RYUtils.h>

@interface RYCommonMethods (SmartHome)

/**
 *  判断字符串是否含有非法字符（字符，emoji）
 *
 *  @param validString 需要验证的字符串
 *
 *  @return YES/NO
 */
+ (BOOL)isValidateString:(NSString *)validString;

@end
