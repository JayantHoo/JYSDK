//
//  OMGRefreshAutoNormalFooter.m
//  gongjian
//
//  Created by champ on 2018/7/11.
//  Copyright © 2018年 Champ. All rights reserved.
//

#import "CPRefreshAutoNormalFooter.h"

@implementation CPRefreshAutoNormalFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare{
    [super prepare];

    // 设置正在刷新状态
    [self setTitle:@"暂无更多数据"  forState:MJRefreshStateNoMoreData];
    [self setTitle:@"上拉加载"   forState:MJRefreshStateIdle];
    [self setTitle:@"松开加载"   forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载"   forState:MJRefreshStateRefreshing];

    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor lightGrayColor];
}

@end
