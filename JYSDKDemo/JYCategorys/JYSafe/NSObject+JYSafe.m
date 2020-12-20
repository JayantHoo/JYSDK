//
//  NSObject+JYSafe.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSObject+JYSafe.h"
#import <objc/runtime.h>
#import "NSObject+JYRuntime.h"
@implementation NSObject (JYSafe)

+(void)load
{
    [NSClassFromString(@"NSObject") swapMethod:@selector(forwardingTargetForSelector:)
                                   currentMethod:@selector(jy_forwardingTargetForSelector:)];
}

-(id)jy_forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorStr = NSStringFromSelector(aSelector);
    // 做一次类的判断，只对 UIResponder 和 NSNull 有效
    if ([[self class] isSubclassOfClass: NSClassFromString(@"UIResponder")] ||
        [self isKindOfClass: [NSNull class]])
    {
        NSLog(@"PROTECTOR: -[%@ %@]", [self class], selectorStr);
        NSLog(@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self);
        // 查看调用栈
        NSLog(@"PROTECTOR: call stack: %@", [NSThread callStackSymbols]);
        
        // 对保护器插入该方法的实现
        Class protectorCls = NSClassFromString(@"JYSafeProtector");
        if (!protectorCls)
        {
            protectorCls = objc_allocateClassPair([NSObject class], "JYSafeProtector", 0);
            objc_registerClassPair(protectorCls);
        }
        
        // 添加方法
        class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],
                            [selectorStr UTF8String]);

        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        
        return instance;
    }
    else
    {
        return nil;
    }
    
    return [self jy_forwardingTargetForSelector:aSelector];
}

// 一个安全的方法实现
- (IMP)safeImplementation:(SEL)aSelector
{
    IMP imp = imp_implementationWithBlock(^()
                                          {
                                              NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
                                          });
    return imp;
}

@end
