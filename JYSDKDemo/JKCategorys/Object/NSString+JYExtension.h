//
//  NSString+JYExtension.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JYExtension)

/**
 *  利用正则表达式去除html代码中的标签和非法字符
 *
 *  @return 返回html代码中的正文
 */
-(instancetype)jy_stringAtHtmlString;


//手机号码中间替换为****
-(NSString *)jy_securePhoneNumber;

/** 去掉两端空格和换行符 */
- (NSString *)jy_stringByTrimmingBlank;

//提取字符串中的数字
-(NSInteger)jy_numberFromString;

@end
