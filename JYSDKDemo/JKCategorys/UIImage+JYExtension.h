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

-(CGFloat) jy_imageHeightFromWidth:(CGFloat) width;

@end
