//
//  UIImage+JYBlur.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JYBlur)

/**
 *  图片高斯模糊
 *
 *  @param sourceImage 目标图片
 *  @param blurLevel  模糊等级 0~1
 *
 *  @return 返回模糊后的照片
 */
+ (UIImage *)jy_bluredImageWithSourceImage:(UIImage *)sourceImage blurLevel:(CGFloat)blurLevel;

@end
