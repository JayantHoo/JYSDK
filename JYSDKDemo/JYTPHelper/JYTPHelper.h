//
//  JYTPHelper.h
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYWCHelper.h"
#import "JYQQHelper.h"
#import "JYWBHelper.h"
#import "JYAliPayHelper.h"

//typedef NS_OPTIONS(NSInteger, JYTPHelperType) {//接入哪个第三方
//    JYTPHelperTypeWechat = 0,       //微信
//    JYTPHelperTypeQQ = 1 << 0,      //QQ
//    JYTPHelperTypeWeibo = 1 << 1,   //微博
//    JYTPHelperTypeAlipay = 1 << 2   //支付宝
//};
//多选项枚举用法
//JYTPHelperType type = JYTPHelperTypeWechat|JYTPHelperTypeQQ|JYTPHelperTypeWeibo|JYTPHelperTypeAlipay;
//if(type&JYTPHelperTypeWechat)

typedef NS_ENUM(NSInteger, LoginType) {
    qqLogin      = 0,        /**< QQ登录       */
    weChatLogin  = 1,        /**< 微信登录      */
    weiBoLogin   = 2,        /**< 微博登录      */
};

typedef NS_ENUM(NSInteger, PayType) {
    aLiPay     = 0,        /**< 支付宝支付    */
    weChatPay  = 1,        /**< 微信支付      */
};

@interface JYTPHelper : NSObject

//注册微信
+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret;
//注册QQ
+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret;
//注册微博
+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI;
//设置支付宝支付回调app scheme
+ (void)registerAlipayScheme:(NSString *) appScheme;

+ (BOOL)handleOpenURL:(NSURL *)url;

//第三方---登录
+ (void)jy_LoginType:(LoginType)loginType finished:(void(^)(JYLoginResponse *response))finished;
//第三方支付（支付签名全部由后台完成）
+ (void)jy_PayInformation:(NSDictionary *)resultDict PayType:(PayType)payType finished:(void(^)(JYPayResponse *response))finished;


@end
