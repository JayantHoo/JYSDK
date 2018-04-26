//
//  NSString+JYDevice.h
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JYDevice)

/**
 获取机型
 */
+ (NSString *)device_model;

/**
 获取运营商
 */
+ (NSString *)device_operator;

/**
 获取品牌
 */
+ (NSString *)device_brand;

/**
 获取IDFA
 */
+ (NSString *)device_IDFA;

/**
 获取操作系统
 */
+ (NSString *)device_system;



//获取app包名
+(instancetype) jy_appName;
//获取app版本
+(instancetype) jy_appVersion;

@end
