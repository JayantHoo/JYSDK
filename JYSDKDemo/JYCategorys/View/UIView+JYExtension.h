//
//  UIView+JYExtension.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JYExtension)

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)jy_isShowingOnKeyWindow;

/**
 * xib创建的view
 */
+ (instancetype)jy_viewFromXib;

/**
 * xib创建的view
 */
+ (instancetype)jy_viewFromXibWithFrame:(CGRect)frame;

/**
 * xib中显示的属性
 */
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;

//设置多个位置圆角
-(void)jy_corner:(UIRectCorner)corners radius:(CGFloat)radius;

//设置颜色渐变
-(void)jy_setGradientWithColors:(NSArray *)colors
                   locations:(NSArray<NSNumber *> *) locations
                    endPoint:(CGPoint)endPoint;

-(void)jy_setGradientWithColors:(NSArray *)colors
                   locations:(NSArray<NSNumber *> *) locations;


@end
