//
//  JYControllerHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYControllerHelper.h"

@implementation JYControllerHelper

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
