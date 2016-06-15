//
//  RoomDataManager.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RoomDataManager.h"

@implementation RoomDataManager

@synthesize home;

#pragma mark - Singleton methods

- (id)init
{
    if(self = [super init])
    {
        //读取本地用户信息
        NSString *homeFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLocalHomeFile];
        NSDictionary *homeDict = [NSDictionary dictionaryWithContentsOfFile:homeFilePath];
        self.home = [[HomeModel alloc] initWithRYDict:homeDict];
        //默认设备列表置空
        self.deviceArray = [NSMutableArray array];
//todo: 添加测试数据 - 需要删除
        /*
        if(!homeDict)
        {
            //使用测试数据
            NSString *testHomePath = [[NSBundle mainBundle] pathForResource:@"Test_Home" ofType:@"txt"];
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:testHomePath];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            self.home = [[HomeModel alloc] initWithRYDict:jsonDict];
            
            NSString *testAvailablePath = [[NSBundle mainBundle] pathForResource:@"Test_Available" ofType:@"txt"];
            NSData *jsonAvaiableData = [[NSData alloc] initWithContentsOfFile:testAvailablePath];
            NSArray *jsonAvailableArray = [NSJSONSerialization JSONObjectWithData:jsonAvaiableData options:0 error:nil];
            self.deviceArray = [NSMutableArray array];
            for(NSDictionary *dictDevice in jsonAvailableArray)
            {
                DeviceModel *dm = [[DeviceModel alloc] initWithRYDict:dictDevice];
                [self.deviceArray addObject:dm];
            }
        }
       */
//end
    }
    return self;
}


+ (instancetype)sharedManager
{
    static RoomDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RoomDataManager alloc] init];
    });
    return manager;
}

#pragma mark - Public methods

- (void)saveHomeData
{
    //保存登录用户信息
    NSDictionary *homeDict = [self.home toDict];
    NSString *homeFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLocalHomeFile];
    [homeDict writeToFile:homeFilePath atomically:NO];
}

- (DeviceModel *)deviceForAddress:(NSString *)address
{
    for(RoomModel *rm in self.home.rooms)
    {
        for(DeviceModel *dm in rm.devices)
        {
            if([dm.address isEqualToString:address])
            {
                return dm;
            }
        }
    }
    return nil;
}

- (NSMutableArray *)availableArray
{
    NSMutableArray *array = [NSMutableArray array];
    for(DeviceModel *dm in self.deviceArray)
    {
        BOOL isAdded = NO;
        for(RoomModel *rm in self.home.rooms)
        {
            for(DeviceModel *dmTemp in rm.devices)
            {
                if([dmTemp.address isEqualToString:dm.address])
                {
                    isAdded = YES;
                    break;
                }
            }
        }
        if(!isAdded)
        {
            [array addObject:dm];
        }
    }
    return array;
}

- (void)addRoom:(RoomModel *)room inHome:(HomeModel *)homeModel
{
    RoomModel *existRoom = nil;
    for(RoomModel *rm in homeModel.rooms)
    {
        if([rm.roomId isEqualToString:room.roomId])
        {
            existRoom = rm;
            break;
        }
    }
    if(existRoom)
    {
        [self updateHomeWithRoom:existRoom];
    }
    else
    {
        [homeModel.rooms addObject:room];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChangedNotification object:nil];
}

- (void)deleteRoom:(RoomModel *)room inHome:(HomeModel *)homeModel
{
    RoomModel *existRoom = nil;
    for(RoomModel *rm in homeModel.rooms)
    {
        if([rm.roomId isEqualToString:room.roomId])
        {
            existRoom = rm;
            break;
        }
    }
    if(existRoom)
    {
        [homeModel.rooms removeObject:existRoom];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChangedNotification object:nil];
}

- (void)updateHomeWithRoom:(RoomModel *)room
{
    for(RoomModel *rm in self.home.rooms)
    {
        if([rm.roomId isEqualToString:room.roomId])
        {
            [rm updateWithRoomModel:room];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChangedNotification object:nil];
}

- (void)addDevice:(DeviceModel *)changedDevice inRoom:(RoomModel *)room
{
    if(nil == room)
    {
        [self updateRoomWithDeviceModel:changedDevice];
    }
    else
    {
        DeviceModel *existDevice = nil;
        for(DeviceModel *dm in room.devices)
        {
            if([dm.address isEqualToString:changedDevice.address])
            {
                existDevice = dm;
                break;
            }
        }
        if(existDevice)
        {
            [existDevice updateWithDeviceModel:changedDevice];
        }
        else
        {
            [room.devices addObject:changedDevice];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
    }
}
- (void)removeDevice:(DeviceModel *)changedDevice inRoom:(RoomModel *)room
{
    if(nil == room)
    {
        for(RoomModel *rm in self.home.rooms)
        {
            for(DeviceModel *dm in rm.devices)
            {
                if([dm.address isEqualToString:changedDevice.address])
                {
                    dm.deviceStatus = kDeviceStatusOffline;
                    break;
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
    }
    else
    {
        DeviceModel *existDevice = nil;
        for(DeviceModel *dm in room.devices)
        {
            if([dm.address isEqualToString:changedDevice.address])
            {
                existDevice = dm;
                break;
            }
        }
        if(existDevice)
        {
            [room.devices removeObject:existDevice];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
    }
}

- (void)updateRoomWithDeviceModel:(DeviceModel *)changedDevice
{
    for(RoomModel *rm in self.home.rooms)
    {
        for(DeviceModel *dm in rm.devices)
        {
            if([dm.address isEqualToString:changedDevice.address])
            {
                [dm updateWithDeviceModel:changedDevice];
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRoomDeviceChangedNotification object:nil];
}

- (void)addListWithDeviceModel:(DeviceModel *)changedDevice
{
    DeviceModel *existDevice = nil;
    for(DeviceModel *dm in self.deviceArray)
    {
        if([dm.address isEqualToString:changedDevice.address])
        {
            existDevice = dm;
            break;
        }
    }
    if(existDevice)
    {
        [existDevice updateWithDeviceModel:changedDevice];
    }
    else
    {
        [self.deviceArray addObject:changedDevice];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
}
- (void)removeListWithDeviceModel:(DeviceModel *)changedDevice
{
    DeviceModel *existDevice = nil;
    for(DeviceModel *dm in self.deviceArray)
    {
        if([dm.address isEqualToString:changedDevice.address])
        {
            existDevice = dm;
            break;
        }
    }
    if(existDevice)
    {
        [self.deviceArray removeObject:existDevice];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
}

- (void)updateListWithDeviceModel:(DeviceModel *)changedDevice
{
    for(DeviceModel *dm in self.deviceArray)
    {
        if([dm.address isEqualToString:changedDevice.address])
        {
            [dm updateWithDeviceModel:changedDevice];
            [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
            break;
        }
    }
}

@end
