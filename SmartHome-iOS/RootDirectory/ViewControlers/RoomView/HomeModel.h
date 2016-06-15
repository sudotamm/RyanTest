//
//  HomeModel.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface HomeModel : RYBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *rooms;

@end
