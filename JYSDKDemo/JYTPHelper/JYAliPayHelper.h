//
//  JYAliPayHelper.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//  //支付宝集成步骤：https://docs.open.alipay.com/204/105295/

#import "JYDefaultHelper.h"

@interface JYAliPayHelper : JYDefaultHelper

//LSApplicationQueriesSchemes
/**
 <!-- 支付宝  URL Scheme 白名单-->
 <string>alipay</string>
 <string>alipayshare</string>
 */


//设置支付宝支付回调app scheme
+ (void)registerAlipayScheme:(NSString *) appScheme;

- (void)jy_PayInformation:(NSDictionary *)resultDict finished:(void(^)(JYPayResponse *response))finished;

@end
