//
//  JYTPHelperConfig.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYTPUserInfo.h"

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

+ (instancetype)loginResponseWithSucess:(BOOL)success userInfo:(JYTPUserInfo *)userInfo uid:(NSString *)uid errorString:(NSString *)errorString;

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

+ (instancetype)payResponseWithSucess:(BOOL)success errorString:(NSString *)errorString;

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

+ (instancetype)shareResponseWithSucess:(BOOL)success errorStr:(NSString *)errorStr;

@end

@interface JYTPHelperConfig : NSObject

@end
