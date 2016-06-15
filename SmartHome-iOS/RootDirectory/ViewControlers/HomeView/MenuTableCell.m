//
//  MenuTableCell.m
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "MenuTableCell.h"

@implementation MenuTableCell

- (void)reloadWithMenuModel:(MenuModel *)mm
{
    self.nameLabel.text = mm.name;
    self.imgView.image = [UIImage imageNamed:mm.image];
    self.imgView.highlightedImage = [UIImage imageNamed:mm.imageHighlight];
}

@end
