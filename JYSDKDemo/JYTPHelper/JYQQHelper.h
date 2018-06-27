//
//  JYQQHelper.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYHelper.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


typedef NS_ENUM(NSInteger, QQShareScene) {
    QQShareSceneSession = 0,        /**< 聊天界面    */
    QQShareSceneQZone   = 1,        /**< QQ空间      */
};

//LSApplicationQueriesSchemes
// QQ、Qzone URL Scheme 白名单
/**
  <string>mqqapi</string>
  <string>mqq</string>
  <string>mqqOpensdkSSoLogin</string>
  <string>mqqconnect</string>
  <string>mqqopensdkdataline</string>
  <string>mqqopensdkgrouptribeshare</string>
  <string>mqqopensdkfriend</string>
  <string>mqqopensdkapi</string>
  <string>mqqopensdkapiV2</string>
  <string>mqqopensdkapiV3</string>
  <string>mqzoneopensdk</string>
  <string>wtloginmqq</string>
  <string>wtloginmqq2</string>
  <string>mqqwpa</string>
  <string>mqzone</string>
  <string>mqzonev2</string>
  <string>mqzoneshare</string>
  <string>wtloginqzone</string>
  <string>mqzonewx</string>
  <string>mqzoneopensdkapiV2</string>
  <string>mqzoneopensdkapi19</string>
  <string>mqzoneopensdkapi</string>
  <string>mqzoneopensdk</string>
*/

@interface JYQQHelper : JYHelper

//注册QQ
+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret;

//只有添加了Schemes该方法才有效
//是否有安装QQ
+(BOOL) jy_isQQAppInstalled;


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

@end
