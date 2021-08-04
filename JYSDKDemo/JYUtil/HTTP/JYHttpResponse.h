//
//  JYHttpResponse.h
//  JTLive
//
//  Created by jayant hoo on 2019/4/28.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 请求数据返回的状态码
typedef NS_ENUM(NSUInteger, JYHTTPResponseCode) {
    JYHTTPResponseCodeSuccess  = 200 ,                     /// 请求成功    (PS：根据自身项目去设置)
    JYHTTPResponseCodeNotLogin = 401 ,                     /// 用户尚未登录,或者Token失效
    JYHTTPResponseCodeNotRegister = 4002 ,                 /// 第三方授权登录未绑定手机号
};

@interface JYHttpResponse : NSObject

@property (nonatomic,readonly,assign) BOOL success;

@property (nonatomic,readonly,assign) JYHTTPResponseCode code;

@property (nonatomic,readonly,strong) id parsedResult;

@property (nonatomic,copy) NSString *msg;

+(instancetype)response:(NSDictionary *) responseObject;

@end

