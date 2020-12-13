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
    CGRect rect=CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
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

//根据宽度获取图片高度
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

/**
 *  图片不被渲染
 *
 */
+ (UIImage *)jy_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
    {   //iOS 7.0+
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        return image;
    }
}

/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 *  图片着色
 */
+ (UIImage *)jy_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(sourceImage.size.width*2, sourceImage.size.height*2));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, sourceImage.size.width * 2, sourceImage.size.height * 2);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, sourceImage.CGImage);
    
    [color set];
    
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, sourceImage.CGImage);
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return destImage;
    
}

/**
 *  将图片旋转到指定的方向
 *
 *  @param sourceImage 要旋转的图片
 *  @param orientation 旋转方向
 *
 *  @return 返回旋转后的图片
 */
+ (UIImage *) jy_fixImageOrientationWithSourceImage:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
        {
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, sourceImage.size.height, sourceImage.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationRight:
        {
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, sourceImage.size.height, sourceImage.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationDown:
        {
            rotate = M_PI;
            rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
        }
            break;
        default:
        {
            rotate = 0.0;
            rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
            translateX = 0;
            translateY = 0;
        }
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), sourceImage.CGImage);
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return destImage;
}


/**
 *  屏幕截图
 */
+ (instancetype) jy_captureScreen:(UIView *)view
{
    // 手动开启图片上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染上下文到图层
    [view.layer renderInContext:ctx];
    
    // 从当前上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)jy_compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    if (!image) {
        return nil;
    }
    if (maxLength<=0) {
        return nil;
    }
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
