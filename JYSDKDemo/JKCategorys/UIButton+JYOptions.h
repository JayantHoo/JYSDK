//
//  UIButton+JYOptions.h
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置Button图片和文字的排列样式
typedef NS_ENUM(NSUInteger, JYButtonEdgeInsetType) {
    JYTitleBottonImageUpType = 0,//图上字下
    JYTitleUpImageBottonType,//图下字上
    JYTitleLeftImageRightType,//图右字左
    JYTitleRightImageLeftType,//图左字右
};

@interface UIButton (JYOptions)

-(void)jy_setNormalTitle:(NSString *)title titleColor:(UIColor *)titleColor;

-(void)jy_setHighlightedTitle:(NSString *)title titleColor:(UIColor *)titleColor;

-(void)jy_setSelectedTitle:(NSString *)title titleColor:(UIColor *)titleColor;

-(void)jy_setDisabledTitle:(NSString *)title titleColor:(UIColor *)titleColor;

-(void)jy_setNormalImage:(NSString *)imageName;

-(void)jy_setHighlightedImage:(NSString *)imageName;

-(void)jy_setSelectedImage:(NSString *)imageName;

-(void)jy_setDisabledImage:(NSString *)imageName;

-(void)jy_setNormalBackgroundImage:(NSString *)imageName;

-(void)jy_setSelectedBackgroundImage:(NSString *)imageName;

-(void)jy_setHighlightedBackgroundImage:(NSString *)imageName;

-(void)jy_setDisabledBackgroundImage:(NSString *)imageName;

-(void)jy_makeButtonEdgeInsetType:(JYButtonEdgeInsetType )type WithSpace:(CGFloat) space;

@end
