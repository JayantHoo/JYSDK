//
//  UIFont+JYScale.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/27.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIFont+JYScale.h"
#import "NSObject+JYRuntime.h"

@implementation UIFont (JYScale)

+(void)load
{
    [NSClassFromString(@"UIFont") swapClassMethod:@selector(systemFontOfSize:) currentMethod:@selector(jy_systemFontOfSize:)];
    [NSClassFromString(@"UIFont") swapClassMethod:@selector(boldSystemFontOfSize:) currentMethod:@selector(jy_boldSystemFontOfSize:)];
    [NSClassFromString(@"UIFont") swapClassMethod:@selector(italicSystemFontOfSize:) currentMethod:@selector(jy_italicSystemFontOfSize:)];
    [NSClassFromString(@"UIFont") swapClassMethod:@selector(systemFontOfSize:weight:) currentMethod:@selector(jy_systemFontOfSize:weight:)];
    [NSClassFromString(@"UIFont") swapClassMethod:@selector(monospacedDigitSystemFontOfSize:weight:) currentMethod:@selector(jy_monospacedDigitSystemFontOfSize:weight:)];
}

#pragma mark - 设置比例字体大小(以6s为标准)
+(UIFont *)jy_systemFontOfSize:(CGFloat) fontSize
{
    return [[self class] jy_systemFontOfSize:JYSCALESIZE(fontSize)];
}

+ (UIFont *)jy_boldSystemFontOfSize:(CGFloat)fontSize
{
    return [[self class] jy_boldSystemFontOfSize:JYSCALESIZE(fontSize)];
}

+ (UIFont *)jy_italicSystemFontOfSize:(CGFloat)fontSize
{
    return [[self class] jy_italicSystemFontOfSize:JYSCALESIZE(fontSize)];
}

+ (UIFont *)jy_systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight
{
    return [[self class] jy_systemFontOfSize:JYSCALESIZE(fontSize) weight:JYSCALESIZE(weight)];
}

+ (UIFont *)jy_monospacedDigitSystemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight
{
    return [[self class] jy_monospacedDigitSystemFontOfSize:JYSCALESIZE(fontSize) weight:JYSCALESIZE(weight)];
}


@end
