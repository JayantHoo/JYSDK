//
//  JYWCHelper.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//  

#import "JYHelper.h"
#import <WXApi.h>


typedef NS_ENUM(NSInteger, WXShareScene) {
    WXShareSceneSession  = 0,        /**< 聊天界面    */
    WXShareSceneMoments = 1,        /**< 朋友圈      */
    WXShareSceneFavorite = 2,        /**< 收藏       */
};

@interface JYWCHelper : JYHelper

//注册微信
+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret;



//LSApplicationQueriesSchemes
//需在info.plist文件中添加白名单
/**
 <!-- 微信 URL Scheme 白名单-->
 <string>wechat</string>
 <string>weixin</string>
 */
//只有添加了微信的Schemes该方法才有效
// 是否有安装微信
+(BOOL) jy_isWXAppInstalled;

#pragma mark - 微信支付
- (void)jy_PayInformation:(NSDictionary *)resultDict finished:(void(^)(JYPayResponse *response))finished;

#pragma mark - 微信分享 [文字不可以分享到朋友圈]
- (void)weChatShareText:(NSString *)text
               finished:(void(^)(JYShareResponse *response))finished;

- (void)weChatShareThumbImage:(UIImage *)thumbImage
                originalImage:(NSData *)originalImageData
                        scene:(WXShareScene)scene
                     finished:(void(^)(JYShareResponse *response))finished;

- (void)weChatShareWebURL:(NSString *)url
              description:(NSString *)description
               thumbImage:(UIImage *)thumbImage
                    title:(NSString *)title
                    scene:(WXShareScene)scene
                 finished:(void(^)(JYShareResponse *response))finished;

- (void)weChatShareMusicURL:(NSString *)musicUrl
               musicDataURL:(NSString *)musicDataUrl
                 thumbImage:(UIImage *)thumbImage
                      title:(NSString *)title
                description:(NSString *)description
                      scene:(WXShareScene)scene
                   finished:(void(^)(JYShareResponse *response))finished;

- (void)weChatShareVideoURL:(NSString *)videoUrl
                 thumbImage:(UIImage *)thumbImage
                      title:(NSString *)title
                description:(NSString *)description
                      scene:(WXShareScene)scene
                   finished:(void(^)(JYShareResponse *response))finished;

@end
