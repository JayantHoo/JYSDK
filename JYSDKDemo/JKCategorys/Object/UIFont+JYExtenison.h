//
//  UIFont+JYExtenison.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/4.
//  Copyright © 2018年 isenu. All rights reserved.
//

// IOS版本
#define JY_IOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])


/// 设置系统的字体大小（YES：粗体 NO：常规）
#define JYFont(__size__,__bold__) ((__bold__)?([UIFont boldSystemFontOfSize:__size__]):([UIFont systemFontOfSize:__size__]))

/// 极细体
#define JYUltralightFont(__size__) ((JY_IOSVersion<9.0)?JYFont(__size__ , YES):[UIFont jy_fontForPingFangSC_UltralightFontOfSize:__size__])

/// 纤细体
#define JYThinFont(__size__)       ((JY_IOSVersion<9.0)?JYFont(__size__ , YES):[UIFont jy_fontForPingFangSC_ThinFontOfSize:__size__])

/// 细体
#define JYLightFont(__size__)      ((JY_IOSVersion<9.0)?JYFont(__size__ , YES):[UIFont jy_fontForPingFangSC_LightFontOfSize:__size__])

// 中等
#define JYMediumFont(__size__)     ((JY_IOSVersion<9.0)?JYFont(__size__ , YES):[UIFont jy_fontForPingFangSC_MediumFontOfSize:__size__])

// 常规
#define JYRegularFont(__size__)    ((JY_IOSVersion<9.0)?JYFont(__size__ , NO):[UIFont jy_fontForPingFangSC_RegularFontOfSize:__size__])

/** 中粗体 */
#define JYSemiboldFont(__size__)   ((JY_IOSVersion<9.0)?JYFont(__size__ , YES):[UIFont jy_fontForPingFangSC_SemiboldFontOfSize:__size__])



/// 苹方常规字体 10
#define JYRegularFont_10 JYRegularFont(10.0f)
/// 苹方常规字体 11
#define JYRegularFont_11 JYRegularFont(11.0f)
/// 苹方常规字体 12
#define JYRegularFont_12 JYRegularFont(12.0f)
/// 苹方常规字体 13
#define JYRegularFont_13 JYRegularFont(13.0f)
/** 苹方常规字体 14 */
#define JYRegularFont_14 JYRegularFont(14.0f)
/// 苹方常规字体 15
#define JYRegularFont_15 JYRegularFont(15.0f)
/// 苹方常规字体 16
#define JYRegularFont_16 JYRegularFont(16.0f)
/// 苹方常规字体 17
#define JYRegularFont_17 JYRegularFont(17.0f)
/// 苹方常规字体 18
#define JYRegularFont_18 JYRegularFont(18.0f)
/// 苹方常规字体 19
#define JYRegularFont_19 JYRegularFont(19.0f)
/// 苹方常规字体 20
#define JYRegularFont_20 JYRegularFont(20.0f)

#import <UIKit/UIKit.h>

@interface UIFont (JYExtenison)

/**
 *  苹方极细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_UltralightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方常规体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_RegularFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中粗体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_SemiboldFontOfSize:(CGFloat)fontSize;

/**
 *  苹方纤细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_ThinFontOfSize:(CGFloat)fontSize;

/**
 *  苹方细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_LightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中黑体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) jy_fontForPingFangSC_MediumFontOfSize:(CGFloat)fontSize;

@end
