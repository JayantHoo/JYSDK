//
//  UIImageView+JYWebImage.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIImageView+JYWebImage.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (JYWebImage)

- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView
{
    [self jy_setImageWithURL:url placeholderImage:placeholder completed:nil];
}


- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder  completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock
{
    [self jy_setImageWithURL:url placeholderImage:placeholder progress:nil completed:completedBlock];
}


- (void)jy_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder progress:(nullable JYWebImageDownloaderProgressBlock)progressBlock completed:(nullable JYWebImageCompletionWithFinishedBlock)completedBlock
{
    if (JYObjectIsNil(url)) {
        url = nil;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}

@end
