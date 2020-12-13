//
//  JYMacros.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#ifndef JYMacros_h
#define JYMacros_h

//AppDelegate
#define JYAPPDELEGATE           (AppDelegate *)[[UIApplication sharedApplication] delegate]
//NSUserDefaults
#define JYUSERDEFAULTS          [NSUserDefaults standardUserDefaults]
//通知中心
#define JYNOTIFICATIONCENTER    [NSNotificationCenter defaultCenter]

// IOS版本
#define JYIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//屏幕尺寸
#define JYSCREENBOUNDS      ([[UIScreen mainScreen] bounds])
#define JYSCREENWIDTH       ([UIScreen mainScreen].bounds.size.width)
#define JYSCREENHEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define JYSTATUSBARHEIGHT   ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define JYNAVIGATIONBARHEIGHT 44

#define JYNAVIGATIONBARANDSTATUSBARHEIGHT (JYSTATUSBARHEIGHT + JYNAVIGATIONBARHEIGHT)


//----------------------------是否是iPhone X------------------------
#define ISiPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

//----------------------------尺寸比例定义------------------------
#define JYAUTOSIZESCALEXFOR6S  (JYSCREENWIDTH/375.0)

#define JYSCALESIZE(x)      (x*JYAUTOSIZESCALEXFOR6S) //比例大小

#define JYFONT(x)      [UIFont systemFontOfSize:(x)]   //设置字体大小
#define JYBOLDFONT(x)   [UIFont boldSystemFontOfSize:(x)] //设置加粗字体大小

// 是否为空对象
#define JYObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define JYStringIsEmpty(__string) ((__string.length == 0) || JYObjectIsNil(__string))

// 字符串不为空
#define JYStringIsNotEmpty(__string)  (!JYStringIsEmpty(__string))

// 数组为空
#define JYArrayIsEmpty(__array) ((JYObjectIsNil(__array)) || (__array.count==0))

// 颜色
#define JYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 颜色+透明度
#define JYAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define JYRandomColor JYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/**
 * 设置颜色
 */
#define JYColorFromHexString(__hexString__) [UIColor colorFromHexString:__hexString__]

// 设置图片
#define JYImageNamed(__imageName) [UIImage imageNamed:__imageName]

// AppCaches 文件夹路径
#define JYCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

// App DocumentDirectory 文件夹路径
#define JYDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]


//-------------------------------—— Log -------------------------------
#ifdef DEBUG
#define JYLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define JYLog(format, ...)
#endif


//-------------------------------—— __weak&&__strong 用法：@weakify(self) @strongify(self)-------------------------------
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/// 适配 iOS 11
#define JYAdjustsScrollViewInsets_Never \
if (@available(iOS 11.0, *)) {\
[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
[UITableView appearance].estimatedRowHeight = 0;\
[UITableView appearance].estimatedSectionFooterHeight = 0;\
[UITableView appearance].estimatedSectionHeaderHeight = 0;\
}\



#endif /* JYMacros_h */
