//
//  HomeDataManager.m
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "HomeDataManager.h"

#define kMenuFileName       @"HomeMenu"

@implementation HomeDataManager

#pragma mark - Singleton methods
- (id)init
{
    if(self = [super init])
    {
        //init menu data from local file
        NSString *path = [[NSBundle mainBundle] pathForResource:kMenuFileName ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        self.menuArray = [NSMutableArray array];
        for(NSDictionary *dict in array)
        {
            MenuModel *mm = [[MenuModel alloc] initWithRYDict:dict];
            [self.menuArray addObject:mm];
        }
    }
    return self;
}

+ (instancetype)sharedManager
{
    static HomeDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HomeDataManager alloc] init];
    });
    return manager;
}



@end
