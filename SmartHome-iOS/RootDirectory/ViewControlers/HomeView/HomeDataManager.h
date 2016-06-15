//
//  HomeDataManager.h
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuModel.h"

@interface HomeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *menuArray;

+ (instancetype)sharedManager;

@end
