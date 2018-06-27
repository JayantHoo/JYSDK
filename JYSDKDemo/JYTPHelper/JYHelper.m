//
//  JYHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/27.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYHelper.h"
#import <objc/runtime.h>

@implementation JYHelper
//可继承单例
+(instancetype) defaultHelper
{
    id defaultHelper = objc_getAssociatedObject(self, @"defaultHelper");
    
    if (!defaultHelper)
    {
        defaultHelper = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"defaultHelper", defaultHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return defaultHelper;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [self defaultHelper];
}
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [[self class] defaultHelper];
}

+ (void)freeDefaultHelper
{
    Class selfClass = [self class];
    objc_setAssociatedObject(selfClass, @"defaultHelper", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(BOOL)handleOpenURL:(NSURL *)url
{
    return YES;//默认为YES//修改在子类中重写方法修改
}

- (void)jy_LoginFinished:(void(^)(JYLoginResponse *response))finished
{}

@end
