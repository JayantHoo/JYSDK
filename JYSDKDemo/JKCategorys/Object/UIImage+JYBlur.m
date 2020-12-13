//
//  UIImage+JYBlur.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIImage+JYBlur.h"
#import <Accelerate/Accelerate.h>
#import <float.h>

@implementation UIImage (JYBlur)
/**
 *  图片高斯模糊
 *
 *  @param sourceImage 目标图片
 *  @param blurLevel  模糊等级 0~1
 *
 *  @return 返回模糊后的照片
 */
+ (UIImage *)jy_bluredImageWithSourceImage:(UIImage *)sourceImage blurLevel:(CGFloat)blurLevel
{
    if (blurLevel < 0.f || blurLevel > 1.f)
    {
        blurLevel = 0.5f;
    }
    int boxSize = (int)(blurLevel * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = sourceImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)  NSLog(@"=========== No Pixelbuffer ==========");
    
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) NSLog(@"========== Error From Convolution %ld============", error);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    
    return returnImage;
}

@end
