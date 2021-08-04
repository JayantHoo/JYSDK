//
//  FBKVOController+JYExtension.m
//  ShellProject
//
//  Created by jayant hoo on 2018/8/15.
//  Copyright © 2018年 jayant hoo. All rights reserved.
//

#import "FBKVOController+JYExtension.h"

@implementation FBKVOController (JYExtension)

- (void)jy_observe:(id)object keyPath:(NSString *)keyPath block:(FBKVONotificationBlock)block
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:block];
}

- (void)jy_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew action:action];
}

@end
