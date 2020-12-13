//
//  UITabBar+JYBage.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UITabBar+JYBage.h"

static NSInteger tabarItemCount = 4;//tabarItem数量

@implementation UITabBar (JYBage)

//显示小红点
- (void)jy_showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self jy_removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / tabarItemCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 9, 9);//圆形大小为10
    [self addSubview:badgeView];
    
}

//隐藏小红点
- (void)jy_hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self jy_removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)jy_removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
