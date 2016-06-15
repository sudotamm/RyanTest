//
//  EntranceTableCell.m
//  SmartHome
//
//  Created by YuanRyan on 6/2/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "EntranceTableCell.h"

@implementation EntranceTableCell

- (void)reloadWithRoomModel:(RoomModel *)room index:(NSInteger)index
{
    self.roomLabel.text = room.name;
    self.deviceNumberLabel.text = [NSString stringWithFormat:@"设备数：%@", @(room.devices.count)];
    NSInteger i = index%4+1;
    self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_demo_%@",@(i)]];
}

@end
