//
//  JYTPHelper.h
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@class JYTPUserInfo;

typedef NS_ENUM(NSInteger, LoginType) {
    qqLogin      = 0,        /**< QQ登录       */
    weChatLogin  = 1,        /**< 微信登录      */
    weiBoLogin   = 2,        /**< 微博登录      */
};

typedef NS_ENUM(NSInteger, PayType) {
    aLiPay     = 0,        /**< 支付宝支付    */
    weChatPay  = 1,        /**< 微信支付      */
};

typedef NS_ENUM(NSInteger, QQShareScene) {
    QQShareSceneSession = 0,        /**< 聊天界面    */
    QQShareSceneQZone   = 1,        /**< QQ空间      */
};

typedef NS_ENUM(NSInteger, WXShareScene) {
    WXShareSceneSession  = 0,        /**< 聊天界面    */
    WXShareSceneMoments = 1,        /**< 朋友圈      */
    WXShareSceneFavorite = 2,        /**< 收藏       */
};

@interface JYLoginResponse : NSObject
/*
 * 第三方登录是否成功
 */
@property (nonatomic, assign, getter=isSucess, readonly) BOOL success;

/*
 * 第三方登录的错误原因
 */
@property (nonatomic, copy, readonly) NSString *errorString;

/*
 * 第三方的唯一标识
 */
@property (nonatomic, copy, readonly) NSString *uid;

/*
 * 第三方的个人信息
 */
@property (nonatomic, copy, readonly) JYTPUserInfo *userInfo;

@end

////////////////////////////////////////  JYPayResponse  /////////////////////////////////////////////
@interface JYPayResponse : NSObject
/*
 * 第三方支付是否成功
 */
@property (nonatomic, assign, getter=isSucess, readonly) BOOL success;

/*
 * 第三方支付的错误原因
 */
@property (nonatomic, copy, readonly) NSString *errorString;

@end

////////////////////////////////////////  JYShareResponse  /////////////////////////////////////////////
@interface JYShareResponse : NSObject
/*
 * 第三方分享是否成功
 */
@property (nonatomic, assign, getter=isSucess, readonly) BOOL success;
/*
 * 第三方分享错误原因
 */
@property (nonatomic, copy, readonly) NSString *errorStr;

@end

@interface JYTPHelper : NSObject

+(instancetype) defaultHelper;
//注册微信
+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret;
//注册QQ
+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret;
//注册微博
+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI;
//设置支付宝支付回调app scheme
+ (void)registerAlipayScheme:(NSString *) appScheme;

+ (BOOL)handleOpenURL:(NSURL *)url;
//是否有安装微信
+(BOOL) jy_isWXAppInstalled;
//是否有安装QQ
+(BOOL) jy_isQQAppInstalled;
//是否有安装微博
+(BOOL) jy_isWeiboAppInstalled;
//第三方---登录
- (void)jy_LoginType:(LoginType)loginType finished:(void(^)(JYLoginResponse *response))finished;
//第三方支付（支付签名全部由后台完成）
- (void)jy_PayInformation:(NSDictionary *)resultDict PayType:(PayType)payType finished:(void(^)(JYPayResponse *response))finished;

#pragma mark - 手机QQ分享  [只有`新闻`(网页)和音乐可以分享到空间]
- (void)qqShareText:(NSString *)text
            finshed:(void(^)(JYShareResponse *response))finished;

- (void)qqShareImage:(NSData *)previewImageData
       originalImage:(NSData *)originalImageData
               title:(NSString *)title
         description:(NSString *)description
            finished:(void(^)(JYShareResponse *response))finished;

- (void)qqShareWebURL:(NSString *)url
                title:(NSString *)title
          description:(NSString *)description
           thumbImage:(UIImage *)thumbImage
                scene:(QQShareScene)scene
             finished:(void(^)(JYShareResponse *response))finished;

/// 分享音乐到QQ previewImageUrl 和 previewImageData只需要有一个即可
- (void)qqShareMusicURL:(NSString *)flashUrl
                jumpURL:(NSString *)jumpUrl
        previewImageURL:(NSString *)previewImageUrl
       previewImageData:(NSData *)previewImageData
                  title:(NSString *)title
            description:(NSString *)description
                  scene:(QQShareScene)scene
               finished:(void(^)(JYShareResponse *response))finished;

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

#pragma mark - 微博分享

- (void)weiboShareText:(NSString *)text
              finished:(void(^)(JYShareResponse *response))finished;

- (void)weiboShareImage:(UIImage *)image
                   text:(NSString *)text
                finshed:(void(^)(JYShareResponse *response))finished;


-(void)weiboShareUrl:(NSString *)url
               title:(NSString *)title
         description:(NSString *)description
               image:(UIImage *)image
            finished:(void(^)(JYShareResponse *response))finished;

@end
