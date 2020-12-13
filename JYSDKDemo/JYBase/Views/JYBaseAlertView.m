//
//  JYBaseAlertView.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYBaseAlertView.h"

@implementation JYBaseAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _canCilckHidden = YES;
        _removeWhenHide = YES;
        [self jy_setupView];
    }
    return self;
}

#pragma mark- UI布局
-(void)jy_setupView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    UIButton *tap = [[UIButton alloc] initWithFrame:self.bounds];
    [tap addTarget:self action:@selector(jy_tapBg) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:tap atIndex:0];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//默认位置大小，z可在子类中重新设置
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
}

-(void)jy_tapBg
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.canCilckHidden) {
        [self hide];
    }
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0.25, 0.25);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.contentView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)hide
{
    self.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (self.removeWhenHide) {
            [self removeFromSuperview];
        }
    }];
    
}

@end
