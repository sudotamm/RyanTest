//
//  EditNameView.h
//  SmartHome
//
//  Created by YuanRyan on 5/24/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditNameConfirmBlock) (NSString *name);

@interface EditNameView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) EditNameConfirmBlock confirmBlock;

- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)confirmButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (void)reloadWithTitle:(NSString *)title
            DefaultName:(NSString *)name
            placeholder:(NSString *)placeholder
                 confirmBlock:(EditNameConfirmBlock)block;

@end
