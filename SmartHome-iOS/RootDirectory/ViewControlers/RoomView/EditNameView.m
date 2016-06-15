//
//  EditNameView.m
//  SmartHome
//
//  Created by YuanRyan on 5/24/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "EditNameView.h"

@implementation EditNameView

#pragma mark - Public methods
- (IBAction)closeButtonClicked:(id)sender
{
    [self endEditing:YES];
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    
}

- (IBAction)confirmButtonClicked:(id)sender
{
    [self endEditing:YES];
    NSString *finalName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isValid = [RYCommonMethods isValidateString:finalName];
    if(isValid)
    {
        self.confirmBlock(finalName);
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:kInvalidName];
    }
    [[RYRootBlurViewManager sharedManger] hideBlurView];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self endEditing:YES];
    [[RYRootBlurViewManager sharedManger] hideBlurView];
}

- (void)reloadWithTitle:(NSString *)title
            DefaultName:(NSString *)name
            placeholder:(NSString *)placeholder
           confirmBlock:(EditNameConfirmBlock)block
{
    self.titleLabel.text = title;
    self.nameTextField.placeholder = placeholder;
    self.nameTextField.text = name;
    self.confirmBlock = block;
}

#pragma mark - UIView methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keypath: %@ value changed", keyPath);
    NSLog(@"self.superview.alpha: %@", @(self.superview.alpha));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
@end
