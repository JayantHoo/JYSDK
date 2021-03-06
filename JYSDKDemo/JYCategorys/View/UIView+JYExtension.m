//
//  UIView+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIView+JYExtension.h"

@implementation UIView (JYExtension)


/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)jy_isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

/**
 * xib创建的view
 */
+ (instancetype)jy_viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


+ (instancetype)jy_viewFromXibWithFrame:(CGRect)frame {
    UIView *view = [self jy_viewFromXib];
    view.frame = frame;
    return view;
}

/**
 * xib中显示的属性
 */
-(void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    [self.layer setMasksToBounds:masksToBounds];
}

@end
