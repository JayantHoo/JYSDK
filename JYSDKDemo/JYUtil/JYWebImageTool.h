//
//  JYWebImageTool.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  下载图片完成的block
 */
typedef void(^JYWebImageCompletionWithFinishedBlock)(UIImage * _Nullable image);
/**
 *  下载图片进度
 */
typedef void(^JYWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize,NSURL * _Nullable targetURL);

@interface JYWebImageTool : NSObject


/**
 *  异步下载图片 带进度
 *
 *  @param url            图片url
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable JYWebImageDownloaderProgressBlock)progressBlock completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock;

/**
 *  解决内存警告
 */
+ (void) clearWebImageCache;

@end
