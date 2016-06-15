//
//  MenuTableCell.h
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;

- (void)reloadWithMenuModel:(MenuModel *)mm;

@end
