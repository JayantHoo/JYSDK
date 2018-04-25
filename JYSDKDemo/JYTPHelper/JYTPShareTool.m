//
//  JYTPShareTool.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTPShareTool.h"
#import "JYTPHelper.h"

@implementation JYTPShareTool

+ (void)shareWebURL:(NSString *)url
              title:(NSString *)title
           subTitle:(NSString *)subTitle
              image:(UIImage *)image
           platform:(JYTPShareType)shareType
           finished:(void(^)(BOOL success))finished
{
    switch (shareType) {
        case WeChatMomentsType:
        {
            if (![WXApi isWXAppInstalled]) return;
            [[JYTPHelper defaultHelper] weChatShareWebURL:url description:subTitle thumbImage:image title:title scene:WXShareSceneMoments finished:^(JYShareResponse *response) {
                if (finished) {
                    finished(response.success);
                }
            }];
        }
            break;
        case WeChatFriendsType:
        {
            if (![WXApi isWXAppInstalled]) return;
            [[JYTPHelper defaultHelper] weChatShareWebURL:url description:subTitle thumbImage:image title:title scene:WXShareSceneSession finished:^(JYShareResponse *response) {
                if (finished) {
                    finished(response.success);
                }
            }];
        }
            break;
        case QQFriendsType:
        {
            if (![QQApiInterface isQQInstalled]) return;
            [[JYTPHelper defaultHelper] qqShareWebURL:url title:title description:subTitle thumbImage:image scene:QQShareSceneSession finished:^(JYShareResponse *response) {
                if (finished) {
                    finished(response.success);
                }
            }];
        }
            break;
        case QQZoneType:
        {
            if (![QQApiInterface isQQInstalled]) return;
            [[JYTPHelper defaultHelper] qqShareWebURL:url title:title description:subTitle thumbImage:image scene:QQShareSceneQZone finished:^(JYShareResponse *response) {
                if (finished) {
                    finished(response.success);
                }
            }];
        }
            break;
        case WeiboType:
        {
            [[JYTPHelper defaultHelper] weiboShareUrl:url title:title description:subTitle image:image finished:^(JYShareResponse *response) {
                if (finished) {
                    finished(response.success);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
