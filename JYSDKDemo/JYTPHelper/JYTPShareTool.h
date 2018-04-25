//
//  JYTPShareTool.h
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JYTPShareType) {
    WeChatMomentsType = 0,//朋友圈
    WeChatFriendsType,//微信好友
    QQFriendsType,//QQ好友
    QQZoneType,//QQ空间
    WeiboType,//新浪微博
};

@interface JYTPShareTool : NSObject

//分享链接
+ (void)shareWebURL:(NSString *)url
              title:(NSString *)title
           subTitle:(NSString *)subTitle
              image:(UIImage *)image
           platform:(JYTPShareType)shareType
           finished:(void(^)(BOOL success))finished;


@end
