//
//  UITabBar+JYBage.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (JYBage)

- (void)jy_showBadgeOnItemIndex:(int)index; //显示小红点

- (void)jy_hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
