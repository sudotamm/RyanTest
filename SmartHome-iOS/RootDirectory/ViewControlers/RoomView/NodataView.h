//
//  NodataView.h
//  SmartHome
//
//  Created by YuanRyan on 6/2/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodataView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

- (void)reloadWithTitle:(NSString *)title
                    tip:(NSString *)tip;

@end
