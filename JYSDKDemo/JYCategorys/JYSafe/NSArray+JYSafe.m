//
//  NSArray+JYSafe.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSArray+JYSafe.h"
#import "NSObject+JYRuntime.h"

@implementation NSArray (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSPlaceholderArray") swapMethod:@selector(initWithObjects:count:)
                                                 currentMethod:@selector(jy_initWithObjects:count:)];
        [NSClassFromString(@"__NSArrayI") swapMethod:@selector(objectAtIndex:)
                                       currentMethod:@selector(jy_objectAtIndex:)];
        [NSClassFromString(@"__NSArray0") swapMethod:@selector(objectAtIndex:)
                                       currentMethod:@selector(jy_zeroObjectAtIndex:)];
        [NSClassFromString(@"__NSSingleObjectArrayI") swapMethod:@selector(objectAtIndex:)
                                                   currentMethod:@selector(jy_singleObjectAtIndex:)];
    });
    
}

- (instancetype)jy_initWithObjects:(id *)objects count:(NSUInteger)cnt
{
    NSUInteger newCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (!objects[i])
        {
            break;
        }
        newCnt++;
    }
    
    return [self jy_initWithObjects:objects count:newCnt];
}

- (id)jy_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        return nil;
    }
    return [self jy_objectAtIndex:index];
}

- (id)jy_zeroObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    return [self jy_zeroObjectAtIndex:index];
}

- (id)jy_singleObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    return [self jy_singleObjectAtIndex:index];
}

@end



@implementation NSMutableArray (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(objectAtIndex:)
                                       currentMethod:@selector(jy_objectAtIndex:)];
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(addObject:)
                                       currentMethod:@selector(jy_addObject:)];
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(removeObjectAtIndex:)
                                       currentMethod:@selector(jy_removeObjectAtIndex:)];
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(replaceObjectAtIndex:withObject:)
                                       currentMethod:@selector(jy_replaceObjectAtIndex:withObject:)];
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(removeObjectsInRange:)
                                       currentMethod:@selector(jy_removeObjectsInRange:)];
        [NSClassFromString(@"__NSArrayM") swapMethod:@selector(insertObject:atIndex:)
                                       currentMethod:@selector(jy_insertObject:atIndex:)];
    });
    
}

- (id)jy_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    return [self jy_objectAtIndex:index];
}

- (void)jy_addObject:(id)anObject
{
    if (!anObject)
    {
        return;
    }
    [self jy_addObject:anObject];
}

- (void)jy_removeObjectAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        return;
    }
    
    return [self jy_removeObjectAtIndex:index];
}

- (void)jy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= [self count])
    {
        return;
    }
    
    if (!anObject)
    {
        return;
    }
    
    [self jy_replaceObjectAtIndex:index withObject:anObject];
}

- (void)jy_removeObjectsInRange:(NSRange)range
{
    if (range.location > self.count)
    {
        return;
    }
    
    if (range.length > self.count)
    {
        return;
    }
    
    if ((range.location + range.length) > self.count)
    {
        return;
    }
    
    return [self jy_removeObjectsInRange:range];
}

- (void)jy_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > self.count)
    {
        return;
    }
    
    if (!anObject)
    {
        return;
    }
    
    [self jy_insertObject:anObject atIndex:index];
}


@end
