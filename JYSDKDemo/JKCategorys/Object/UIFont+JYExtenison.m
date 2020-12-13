//
//  UIFont+JYExtenison.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

/**
 *
 (
 "PingFangSC-Ultralight",
 "PingFangSC-Regular",
 "PingFangSC-Semibold",
 "PingFangSC-Thin",
 "PingFangSC-Light",
 "PingFangSC-Medium"
 )
 */
/**
 *  极细体
 */
static NSString *const JYPingFangSC_Ultralight = @"PingFangSC-Ultralight";
/**
 *  常规体
 */
static NSString *const JYPingFangSC_Regular = @"PingFangSC-Regular";
/**
 *  中粗体
 */
static NSString *const JYPingFangSC_Semibold = @"PingFangSC-Semibold";
/**
 *  纤细体
 */
static NSString *const JYPingFangSC_Thin = @"PingFangSC-Thin";
/**
 *  细体
 */
static NSString *const JYPingFangSC_Light = @"PingFangSC-Light";
/**
 *  中黑体
 */
static NSString *const JYPingFangSC_Medium = @"PingFangSC-Medium";

#import "UIFont+JYExtenison.h"

@implementation UIFont (JYExtenison)

/**
 *  苹方极细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_UltralightFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Ultralight size:fontSize];
}

/**
 *  苹方常规体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_RegularFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Regular size:fontSize];
}

/**
 *  苹方中粗体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_SemiboldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Semibold size:fontSize];
}

/**
 *  苹方纤细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_ThinFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Thin size:fontSize];
}

/**
 *  苹方细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_LightFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Light size:fontSize];
}

/**
 *  苹方中黑体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_MediumFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:JYPingFangSC_Medium size:fontSize];
}

@end
