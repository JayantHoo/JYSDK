//
//  NSString+JYSafe.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSString+JYSafe.h"
#import "NSObject+JYRuntime.h"

@implementation NSString (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSCFConstantString") swapMethod:@selector(substringFromIndex:)
                                                 currentMethod:@selector(lyConstant_substringFromIndex:)];
        
        [NSClassFromString(@"NSTaggedPointerString") swapMethod:@selector(substringFromIndex:)
                                                  currentMethod:@selector(lyPoint_substringFromIndex:)];
        
        [NSClassFromString(@"__NSCFConstantString") swapMethod:@selector(substringToIndex:)
                                                 currentMethod:@selector(lyConstant_substringToIndex:)];
        
        [NSClassFromString(@"NSTaggedPointerString") swapMethod:@selector(substringToIndex:)
                                                  currentMethod:@selector(lyPoint_substringToIndex:)];
        
        [NSClassFromString(@"__NSCFConstantString") swapMethod:@selector(substringWithRange:)
                                                 currentMethod:@selector(lyConstant_substringWithRange:)];
        
        [NSClassFromString(@"NSTaggedPointerString") swapMethod:@selector(substringWithRange:)
                                                  currentMethod:@selector(lyPoint_substringWithRange:)];
    });
    
}

- (NSString *)lyConstant_substringFromIndex:(NSUInteger)from
{
    if (from > self.length )
    {
        return nil;
    }
    return [self lyConstant_substringFromIndex:from];
}

- (NSString *)lyPoint_substringFromIndex:(NSUInteger)from
{
    if (from > self.length )
    {
        return nil;
    }
    return [self lyPoint_substringFromIndex:from];
}

- (NSString *)lyConstant_substringToIndex:(NSUInteger)to
{
    if (to > self.length )
    {
        return nil;
    }
    return [self lyConstant_substringToIndex:to];
}

- (NSString *)lyPoint_substringToIndex:(NSUInteger)to
{
    if (to > self.length )
    {
        return nil;
    }
    return [self lyPoint_substringToIndex:to];
}

- (NSString *)lyConstant_substringWithRange:(NSRange)range
{
    if (range.location > self.length)
    {
        return nil;
    }
    
    if (range.length > self.length)
    {
        return nil;
    }
    
    if ((range.location + range.length) > self.length)
    {
        return nil;
    }
    return [self lyConstant_substringWithRange:range];
}

- (NSString *)lyPoint_substringWithRange:(NSRange)range
{
    if (range.location > self.length)
    {
        return nil;
    }
    
    if (range.length > self.length)
    {
        return nil;
    }
    
    if ((range.location + range.length) > self.length)
    {
        return nil;
    }
    return [self lyPoint_substringWithRange:range];
}

@end



@implementation NSMutableString (JYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"NSString") swapMethod:@selector(substringFromIndex:)
                                     currentMethod:@selector(jy_substringFromIndex:)];
        
        [NSClassFromString(@"NSString") swapMethod:@selector(substringToIndex:)
                                     currentMethod:@selector(jy_substringToIndex:)];
        
        [NSClassFromString(@"NSString") swapMethod:@selector(substringWithRange:)
                                     currentMethod:@selector(jy_substringWithRange:)];
    });
    
}

- (NSString *)jy_substringFromIndex:(NSUInteger)from
{
    if (from > self.length )
    {
        return nil;
    }
    return [self jy_substringFromIndex:from];
}

- (NSString *)jy_substringToIndex:(NSUInteger)to
{
    if (to > self.length )
    {
        return nil;
    }
    return [self jy_substringToIndex:to];
}

- (NSString *)jy_substringWithRange:(NSRange)range
{
    if (range.location > self.length)
    {
        return nil;
    }
    
    if (range.length > self.length)
    {
        return nil;
    }
    
    if ((range.location + range.length) > self.length)
    {
        return nil;
    }
    return [self jy_substringWithRange:range];
}


@end
