//
//  JYAliPayHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYAliPayHelper.h"
#import <AlipaySDK/AlipaySDK.h>

@interface JYAliPayHelper()
@end

@implementation JYAliPayHelper

+ (void)registerAlipayScheme:(NSString *) appScheme
{
    [[NSUserDefaults standardUserDefaults] setObject:appScheme forKey:@"alipayScheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)handleOpenURL:(NSURL *)url
{
    return [[self defaultHelper] handleOpenURL:url];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果 = %@",resultDic);
            //            9000    订单支付成功
            //            8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
            //            4000    订单支付失败
            //            5000    重复请求
            //            6001    用户中途取消
            //            6002    网络连接出错
            //            6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
            //            其它    其它支付错误
            if (self.payFinished) {
                BOOL result = NO;
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    result = YES;
                }
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:result errorString:resultDic[@"resultStatus"]];
                self.payFinished(response);
            }
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果 = %@",resultDic);
            if (self.payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:true errorString:nil];
                self.payFinished(response);
            }
        }];
    }
    return YES;
}

-(void)jy_PayInformation:(NSDictionary *)resultDict finished:(void (^)(JYPayResponse *))finished
{
    self.payFinished = finished;
    NSString *appScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"alipayScheme"];

    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [resultDict objectForKey:@"orderString"];

    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"调用支付结果开始支付 = %@",resultDic);
    }];
}

@end
