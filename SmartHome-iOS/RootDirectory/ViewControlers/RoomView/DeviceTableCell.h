//
//  DeviceTableCell.h
//  SmartHome
//
//  Created by YuanRyan on 5/5/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIImageView *icnImgView;
@property (nonatomic, weak) IBOutlet UIImageView *topLineImgView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomLineImgView;

- (void)reloadWithDeviceModel:(DeviceModel *)dm;


@end
