//
//  UIView+ShakeAnimation.m
//  SmartHome
//
//  Created by YuanRyan on 5/25/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "UIView+ShakeAnimation.h"

@implementation UIView (ShakeAnimation)

- (void)addShakeAnimation
{
    [self removeShakeAnimation];
    
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性，周期时长
    [animation setDuration:0.08];
    //抖动角度
    animation.fromValue = @(-M_1_PI/10);
    animation.toValue = @(M_1_PI/10);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self.layer addAnimation:animation forKey:@"shakeAnimation"];
}

- (void)pauseShakeAnimation
{
    self.layer.speed = 0.0;
}

- (void)resumeShakeAnimation
{
    self.layer.speed = 1.f;
}

- (void)removeShakeAnimation
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

@end
