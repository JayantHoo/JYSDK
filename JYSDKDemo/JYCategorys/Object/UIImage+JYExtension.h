//
//  UIImage+JYExtension.h
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JYExtension)

//圆角图片处理
- (instancetype)jy_circleImage;

+(instancetype)imageWithUrl:(NSString *)url;

//颜色转图片
+(UIImage*) jy_imageWithColor:(UIColor*) color;

//图片拉伸
+ (UIImage *)jy_resizedImage:(NSString *)name;
//图片拉伸
+(UIImage *)jy_resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

//修改图片的尺寸
- (UIImage *)jy_scaleToSize:(CGSize)size;
//根据宽度获取图片高度（图片比例）
-(CGFloat) jy_imageHeightFromWidth:(CGFloat) width;



/**
 *  图片不被渲染
 *
 */
+ (UIImage *)jy_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName;

/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 *  图片着色
 */
+ (UIImage *)jy_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color;


/**
 *  将图片旋转到指定的方向
 *
 *  @param sourceImage 要旋转的图片
 *  @param orientation 旋转方向
 *
 *  @return 返回旋转后的图片
 */
+ (UIImage *) jy_fixImageOrientationWithSourceImage:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation;

/**
 *  屏幕截图
 */
+ (instancetype) jy_captureScreen:(UIView *)view;

//按区域截图
+ (UIImage *)jy_captureScreenView:(UIView *)view inRect:(CGRect)rect;

// 压缩到32字节的图片
+ (UIImage *)jy_compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
