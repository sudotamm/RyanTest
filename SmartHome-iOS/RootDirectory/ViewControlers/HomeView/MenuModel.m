//
//  MenuModel.m
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (MenuType)menuType
{
    return (MenuType)(self.type.integerValue);
}

@end
