//
//  JYDefaultHelper.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/27.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYTPHelperConfig.h"

@interface JYDefaultHelper : NSObject
/*
 *  第三方登录的回调
 */
@property (nonatomic, copy) void(^loginFinished)(JYLoginResponse *response);

/*
 *  第三方支付的回调
 */
@property (nonatomic, copy) void(^payFinished)(JYPayResponse *response);
/*
 *  第三方分享的回调
 */
@property (nonatomic, copy) void(^shareFinished)(JYShareResponse *response);

+(instancetype) defaultHelper;
//iOS9以后
//- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
//ios9之前
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
+(BOOL)handleOpenURL:(NSURL *)url;
//释放单例(内存不够用的话可能需要释放单例)
+ (void)freeDefaultHelper;
//登录方法
- (void)jy_LoginFinished:(void(^)(JYLoginResponse *response))finished;

@end
