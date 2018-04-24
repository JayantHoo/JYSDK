//
//  JYTPUserInfo.m
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTPUserInfo.h"

@implementation JYTPUserInfo

static JYTPUserInfo *_userInfo;

+ (instancetype)userInfo{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[JYTPUserInfo alloc] init];
    });
    
    return _userInfo;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [super allocWithZone:zone];
    });
    return _userInfo;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _userInfo;
}

@end
