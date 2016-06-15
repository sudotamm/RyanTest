//
//  DeviceCollectionCell.h
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceCollectionCell;

typedef void (^DeviceDeleteBlock) (DeviceCollectionCell *cell);
typedef void (^DeviceEditBlock) (DeviceCollectionCell *cell);

@interface DeviceCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIImageView *icnImgView;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *editButton;

@property (nonatomic, copy) DeviceDeleteBlock deleteBlock;
@property (nonatomic, copy) DeviceEditBlock editBlock;

- (void)reloadWithDeviceModel:(DeviceModel *)dm
                     selected:(BOOL)selected
                  deleteBlock:(DeviceDeleteBlock)db
                    editBlock:(DeviceEditBlock)eb;

- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)editButtonClicked:(id)sender;

@end
