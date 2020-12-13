//
//  JYLocalNotifationCenter.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface JYLocalNotifationCenter : NSObject



/**
 注册本地通知
 在appdelegate的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法中调用
 @param application application
 @param delegate appdelegate
 */
+(void)registerLocalNotificationWithApplication:(UIApplication *)application
                                       delegate:(id) delegate;

/**
 发送本地通知
 
 @param title 标题
 @param body 内容
 @param fireDate 发送时间
 @param userInfo 额外的信息
 */
+(void)sendLocalNotifation:(NSString *)title
                      body:(NSString *)body
                  fireDate:(NSDate *)fireDate
                  userInfo:(NSDictionary *)userInfo;

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key;

+(void)cancelAllLocalNotifation;

@end
