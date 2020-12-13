//
//  UIImageView+JYWebImage.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYWebImageTool.h"

@interface UIImageView (JYWebImage)
/**
 *  异步获取图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图片
 */
- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView;
/**
 *  异步获取图片 返回下载成功的图片
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param completedBlock 下载完成的block回调
 */
- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder  completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock;
/**
 *  异步获取图片 带进度
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder progress:(nullable JYWebImageDownloaderProgressBlock)progressBlock completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock;

@end
