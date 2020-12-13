//
//  JYWBHelper.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYDefaultHelper.h"
#import <WeiboSDK.h>

@interface JYWBHelper : JYDefaultHelper

//LSApplicationQueriesSchemes
/**
 <!-- 新浪微博 URL Scheme 白名单-->
 <string>sinaweibohd</string>
 <string>sinaweibo</string>
 <string>sinaweibosso</string>
 <string>weibosdk</string>
 <string>weibosdk2.5</string>
 */

//注册微博
+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI;

//只有添加了Schemes该方法才有效
//是否有安装微博
+(BOOL) jy_isWeiboAppInstalled;


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
