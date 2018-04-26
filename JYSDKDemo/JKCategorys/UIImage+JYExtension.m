//
//  UIImage+JYExtension.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIImage+JYExtension.h"

@implementation UIImage (JYExtension)

//圆角图(在SDWebImage sd_set方法的block中多次执行该方法会造成内存泄漏)
- (instancetype)jy_circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 绘制图片
    [self drawInRect:rect];
    // 获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    return image;
}

+(instancetype)imageWithUrl:(NSString *)url
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

//颜色转图片
+(UIImage*) jy_imageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//图片拉伸
+ (UIImage *)jy_resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.49 topCapHeight:image.size.height * 0.49];
}

+(UIImage *)jy_resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image=[UIImage imageNamed:name];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*left topCapHeight:image.size.height*top];
    return image;
}
//修改图片的尺寸
- (UIImage *)jy_scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

-(CGFloat) jy_imageHeightFromWidth:(CGFloat) width
{
    CGFloat itemW = width;
    CGFloat itemH = 0;
    //根据image的比例来设置高度
    if (self.size.width) {
        itemH = self.size.height / self.size.width * itemW;
    }
    
    return itemH;
}

@end
