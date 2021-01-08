//
//  NSDictionary+JYSafe.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSDictionary+JYSafe.h"
#import "NSObject+JYRuntime.h"

@implementation NSDictionary (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"NSDictionary") swapMethod:@selector(initWithObjects:forKeys:count:)
                                         currentMethod:@selector(jy_initWithObjects:forKeys:count:)];;
    });
    
}

- (instancetype)jy_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        id key = keys[i];
        id obj = objects[i];
        if (!key)
        {
            continue;
        }
        if (!obj)
        {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    
    return [self jy_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end


@implementation NSMutableDictionary (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSDictionaryM") swapMethod:@selector(setObject:forKey:)
                                            currentMethod:@selector(jy_setObject:forKey:)];
    });
    
}

- (void)jy_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject)
    {
        return;
    }
    if (!aKey)
    {
        return;
    }
    [self jy_setObject:anObject forKey:aKey];
}

@end
