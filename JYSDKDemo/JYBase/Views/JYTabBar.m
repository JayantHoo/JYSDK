//
//  JYTabBar.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/3.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTabBar.h"

@interface JYTabBar ()
/// divider
@property (nonatomic, readwrite, weak) UIView *divider ;
@end

@implementation JYTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        /// 去掉tabBar的分割线,以及背景图片
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage jy_resizedImage:@"imageName"]];
        
        /// 添加细线,
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = JYColor(167.0f, 167.0f, 170.0f);
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.divider];
    self.divider.jy_height = .55f;
    self.divider.jy_width = JYSCREENWIDTH;
}

@end
