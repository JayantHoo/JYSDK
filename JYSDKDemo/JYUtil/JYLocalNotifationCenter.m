//
//  JYLocalNotifationCenter.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYLocalNotifationCenter.h"

@implementation JYLocalNotifationCenter

//注册本地通知
+(void)registerLocalNotificationWithApplication:(UIApplication *)application
                                       delegate:(id) delegate
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
        
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    }
    
}

+(void)sendLocalNotifation:(NSString *)title
                      body:(NSString *)body
                  fireDate:(NSDate *)fireDate
                  userInfo:(NSDictionary *)userInfo
{
    if (@available(iOS 10.0, *)) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        
        content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
        content.userInfo = userInfo;
        content.sound = [UNNotificationSound defaultSound];
        
        NSTimeInterval future = [NSDate jy_secondFromFuture:fireDate];
        if (future<0) {
            return;
        }
        // 在 设定时间 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:future repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"GiftRemind"
                                                                              content:content trigger:trigger];
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
    } else {
        // 1.创建一个本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        // 1.1.设置通知发出的时间
        localNote.fireDate = fireDate;
        localNote.timeZone = [NSTimeZone systemTimeZone];
        // 1.2.设置通知内容
        localNote.alertBody = body;
        // 1.3.设置锁屏时,字体下方显示的一个文字
        localNote.alertTitle = title;
        localNote.hasAction = YES;
        // 1.5.设置通过到来的声音
        localNote.soundName = UILocalNotificationDefaultSoundName;
        // 1.6.设置应用图标左上角显示的数字
        localNote.applicationIconBadgeNumber = 0;
        // 1.7.设置一些额外的信息
        localNote.userInfo = userInfo;
        // 2.执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key
{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo)
        {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil)
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

+(void)cancelAllLocalNotifation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
