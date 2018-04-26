//
//  UIView+JYRect.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIView+JYRect.h"

@implementation UIView (JYRect)

- (CGSize)jy_size
{
    return self.frame.size;
}

- (void)setJy_size:(CGSize)jy_size
{
    CGRect frame = self.frame;
    frame.size = jy_size;
    self.frame = frame;
}

- (CGFloat)jy_width
{
    return self.frame.size.width;
}

- (CGFloat)jy_height
{
    return self.frame.size.height;
}

- (void)setJy_width:(CGFloat)jy_width
{
    CGRect frame = self.frame;
    frame.size.width = jy_width;
    self.frame = frame;
}

- (void)setJy_height:(CGFloat)jy_height
{
    CGRect frame = self.frame;
    frame.size.height = jy_height;
    self.frame = frame;
}

- (CGFloat)jy_centerX
{
    return self.center.x;
}

- (void)setJy_centerX:(CGFloat)jy_centerX
{
    CGPoint center = self.center;
    center.x = jy_centerX;
    self.center = center;
}

- (CGFloat)jy_centerY
{
    return self.center.y;
}

- (void)setJy_centerY:(CGFloat)jy_centerY
{
    CGPoint center = self.center;
    center.y = jy_centerY;
    self.center = center;
}

-(CGFloat)jy_left
{
    return self.frame.origin.x;
}

- (CGFloat)jy_right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)jy_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)jy_top
{
    return self.frame.origin.y;
}

- (void)setJy_top:(CGFloat)jy_top
{
    CGRect frame = self.frame;
    frame.origin.y = jy_top;
    self.frame = frame;
}

- (void)setJy_right:(CGFloat)jy_right
{
    CGRect frame = self.frame;
    frame.origin.x = jy_right - frame.size.width;
    self.frame = frame;
}

- (void)setJy_left:(CGFloat)jy_left
{
    CGRect frame = self.frame;
    frame.origin.x = jy_left;
    self.frame = frame;
}

- (void)setJy_bottom:(CGFloat)jy_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = jy_bottom - frame.size.height;
    self.frame = frame;
}

@end
