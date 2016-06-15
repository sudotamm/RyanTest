//
//  UIStoryboard+Manager.m
//  Shinkong
//
//  Created by YuanRyan on 6/11/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "UIStoryboard+Manager.h"

@implementation UIStoryboard (Manager)

+ (instancetype)mainStoryBoard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (instancetype)contentStoryBoard
{
    return [UIStoryboard storyboardWithName:@"Content" bundle:nil];
}


@end
