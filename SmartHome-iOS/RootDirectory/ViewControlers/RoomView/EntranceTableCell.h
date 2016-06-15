//
//  EntranceTableCell.h
//  SmartHome
//
//  Created by YuanRyan on 6/2/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntranceTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *roomLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceNumberLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;

- (void)reloadWithRoomModel:(RoomModel *)room index:(NSInteger)index;

@end
