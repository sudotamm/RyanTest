//
//  MenuModel.h
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

typedef NS_ENUM(NSInteger, MenuType) {
    kMenuTypeHome = 0,
    kMenuTypeRoom,
    kMenuTypeSetting
};

@interface MenuModel : RYBaseModel

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *imageHighlight;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *viewController;

@property (nonatomic, assign) MenuType menuType;
@end
