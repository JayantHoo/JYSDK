//
//  JYMacros.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#ifndef JYMacros_h
#define JYMacros_h

#define APPDELEGATE    (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUSBARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define NAVIGATIONBARHEIGHT 44

#define NAVIGATIONBARANDSTATUSBARHEIGHT (STATUSBARHEIGHT + NAVIGATIONBARHEIGHT)


//----------------------------是否是iPhone X------------------------
#define ISiPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

//----------------------------尺寸比例定义------------------------
#define AUTOSIZESCALEXFOR6S  (SCREENWIDTH/375.0)

#define SCALELENGTH(x)      (x*AUTOSIZESCALEXFOR6S) //比例长度

#define SCALEFONT(x)      [UIFont systemFontOfSize:x*autoSizeScaleXFor6s]   //字体比例大小

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

#endif /* JYMacros_h */
