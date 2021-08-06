//
//  OMGRefreshNormalHeader.m
//  gongjian
//
//  Created by champ on 2018/7/11.
//  Copyright © 2018年 Champ. All rights reserved.
//

#import "CPRefreshNormalHeader.h"

@implementation CPRefreshNormalHeader

- (void)prepare{
    
    [super prepare];

    // 设置普通状态
    
    [self setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态
    [self setTitle:@"松开刷新"  forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态
    [self setTitle:@"正在加载"  forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置状态图片
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor lightGrayColor];
}

@end
