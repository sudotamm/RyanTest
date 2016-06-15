//
//  DeviceControlView.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceControlView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *onOffImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *onOffButton;
@property (nonatomic, strong) DeviceModel *deviceModel;

- (void)reloadWithDeviceModel:(DeviceModel *)dm;
- (IBAction)ofOffButtonClicked:(id)sender;


@end
