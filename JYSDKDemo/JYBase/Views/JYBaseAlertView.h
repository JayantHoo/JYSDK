//
//  JYBaseAlertView.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYBaseAlertView : UIView

//子类自定义布局需要添加到该View
@property (nonatomic,strong) UIView *contentView;/// 内容视图

@property (nonatomic,assign) BOOL canCilckHidden;/// 是否可以点击遮盖层隐藏,默认为YES

// 消失后是否从父类移除 yes:移除   默认：移除
@property (nonatomic, assign) BOOL removeWhenHide;

- (void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
