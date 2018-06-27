//
//  JYTPHelper.m
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTPHelper.h"

@interface JYTPHelper ()

@end


@implementation JYTPHelper

+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret
{
    [JYQQHelper registerQQApp:qqAppId secret:qqSecret];
}

+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret {

    [JYWCHelper registerWeChatAppid:wxAppId secret:wxSecret];
}

+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI {
    [JYWBHelper registerWeiboApp:wbAppKey secret:wbSecret redirectURI:redirectURI];
}

+ (void)registerAlipayScheme:(NSString *) appScheme
{
    [JYAliPayHelper registerAlipayScheme:appScheme];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return  [JYAliPayHelper handleOpenURL:url] | [JYQQHelper handleOpenURL:url] | [JYWCHelper handleOpenURL:url] |
    [JYWBHelper handleOpenURL:url];
}

#pragma mark 第三方登录
+ (void)jy_LoginType:(LoginType)loginType finished:(void(^)(JYLoginResponse *response))finished
{
    if (loginType == qqLogin) {

        [[JYQQHelper defaultHelper] jy_LoginFinished:finished];

    } else if (loginType == weChatLogin) {

        [[JYWCHelper defaultHelper] jy_LoginFinished:finished];

    } else {
        [[JYWBHelper defaultHelper] jy_LoginFinished:finished];
    }
}

#pragma mark - 第三方支付
+ (void)jy_PayInformation:(NSDictionary *)resultDict PayType:(PayType)payType finished:(void(^)(JYPayResponse *response))finished
{
    if (payType == weChatPay) { // 微信支付
        [[JYWCHelper defaultHelper] jy_PayInformation:resultDict finished:finished];
    } else { // 支付宝支付
        [[JYAliPayHelper defaultHelper] jy_PayInformation:resultDict finished:finished];
    }

}


  

@end
