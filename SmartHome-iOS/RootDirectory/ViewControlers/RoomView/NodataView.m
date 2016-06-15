//
//  NodataView.m
//  SmartHome
//
//  Created by YuanRyan on 6/2/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "NodataView.h"

@implementation NodataView

- (void)reloadWithTitle:(NSString *)title
                    tip:(NSString *)tip
{
    self.titleLabel.text = title;
    self.tipLabel.text = tip;
}

@end
