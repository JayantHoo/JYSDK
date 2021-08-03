//
//  JYWebImageTool.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYWebImageTool.h"
#import <SDWebImageManager.h>

@implementation JYWebImageTool
/**
 *  异步下载图片 带进度
 *
 *  @param url            图片url
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */

+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable JYWebImageDownloaderProgressBlock)progressBlock completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}

+ (UIImage *_Nullable)jy_loadImageWithUrl:(NSString *_Nullable)url {
    __block UIImage *tempImage = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString: url] options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        tempImage = image;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return tempImage;
}

/**
 *  解决内存警告
 */
+ (void)clearWebImageCache
{
    // 赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        NSLog(@"**** Async clear all disk cached images ****");
        
    }];
    
    // 赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
