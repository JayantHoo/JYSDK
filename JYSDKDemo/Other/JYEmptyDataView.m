//
//  JYEmptyDataView.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYEmptyDataView.h"

@interface JYEmptyDataView ()

/// imageView <图片>
@property (nonatomic , readwrite , weak) UIImageView *imageView;
/// tipsLabel <信息提示>
@property (nonatomic , readwrite , weak) UILabel *tipsLabel;
/// 重新加载
@property (nonatomic , readwrite , weak) UIButton *reloadButton;
/** 重新加载block */
@property (nonatomic , readwrite , copy) void(^reloadBlock)(void);
@end

@implementation JYEmptyDataView



#pragma mark - Private Method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 事件处理Or辅助方法
- (void)_reloadBtnDidClicked:(UIButton *)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !self.reloadBlock?:self.reloadBlock();
    });
}
#pragma mark - Private Method
- (void)_setup{
    self.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4"];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    /// imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self addSubview:imageView];
    
    /// tipsLabel
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsLabel.text = nil;
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel = tipsLabel;
    [self addSubview:tipsLabel];
    
    /// reloadButton
    UIButton * reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
    reloadButton.titleLabel.font =[UIFont systemFontOfSize:15.f];
    [reloadButton setTitleColor:[UIColor colorWithRed:(10 / 255.0) green:(193 / 255.0) blue:(42 / 255.0) alpha:1] forState:UIControlStateNormal];
    [reloadButton setTitle:@"重新连接" forState:UIControlStateNormal];
    reloadButton.layer.cornerRadius = 4.f;
    reloadButton.layer.borderColor = [UIColor colorWithRed:(10 / 255.0) green:(193 / 255.0) blue:(42 / 255.0) alpha:1].CGColor;
    reloadButton.layer.borderWidth = 1.f;
    reloadButton.adjustsImageWhenHighlighted = YES;
    [reloadButton addTarget:self action:@selector(_reloadBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.reloadButton = reloadButton;
    [self addSubview:reloadButton];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipsLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 34));
    }];
}

@end
