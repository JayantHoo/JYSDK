//
//  UIButton+JYOptions.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIButton+JYOptions.h"

@implementation UIButton (JYOptions)

-(void)jy_setNormalTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

-(void)jy_setHighlightedTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
}

-(void)jy_setSelectedTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitleColor:titleColor forState:UIControlStateSelected];
}

-(void)jy_setDisabledTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitleColor:titleColor forState:UIControlStateDisabled];
}

-(void)jy_setNormalImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)jy_setHighlightedImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(void)jy_setSelectedImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

-(void)jy_setDisabledImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

-(void)jy_setNormalBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)jy_setSelectedBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

-(void)jy_setHighlightedBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(void)jy_setDisabledBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

-(void)jy_makeButtonEdgeInsetType:(JYButtonEdgeInsetType )type WithSpace:(CGFloat) space
{
    switch (type) {
        case JYTitleBottonImageUpType:
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width, -self.imageView.frame.size.height - space/2.0,0.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - space/2.0, 0.0,0.0, -self.titleLabel.intrinsicContentSize.width)];
            
        }
            break;
        case JYTitleUpImageBottonType:
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width, self.imageView.frame.size.height + space/2.0,0.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(self.titleLabel.intrinsicContentSize.height + space/2.0, 0.0,0.0, -self.titleLabel.intrinsicContentSize.width)];
            
        }
            break;
        case JYTitleLeftImageRightType:
        {
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width-space/2.0, 0.0,self.imageView.frame.size.width)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, self.titleLabel.intrinsicContentSize.width,0.0, -self.titleLabel.intrinsicContentSize.width-space/2.0)];
        }
            break;
        case JYTitleRightImageLeftType:
        {
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,0.0, 0.0, - space/2.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,  - space/2.0,0.0, 0.0)];
        }
            break;
        default:
            break;
    }
}

@end
