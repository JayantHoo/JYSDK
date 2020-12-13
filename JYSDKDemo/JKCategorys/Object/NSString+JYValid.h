//
//  NSString+JYValid.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JYValid)

/** 邮箱验证 */
- (BOOL)jy_isValidEmail;

/** 手机号码验证 */
- (BOOL)jy_isValidPhoneNum;

/** 车牌号验证 */
- (BOOL)jy_isValidCarNo;

/** 网址验证 */
- (BOOL)jy_isValidUrl;

/** 邮政编码 */
- (BOOL)jy_isValidPostalcode;

/** 纯汉字 */
- (BOOL)jy_isValidChinese;

/** 是否符合IP格式，xxx.xxx.xxx.xxx*/
- (BOOL)jy_isValidIP;

/** 身份证验证 refer to http://blog.csdn.net/afyzgh/article/details/16965107*/
- (BOOL)jy_isValidIdCardNum;

//判断是否含有非法字符 yes 有  no没有
- (BOOL)jy_isJudgeTheillegalCharacter;

/// 检测字符串是否包含中文
+( BOOL)jy_isContainChinese:(NSString *)str;

/// 整型
+ (BOOL)jy_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)jy_isPureFloat:(NSString *)string;

/// 纯数字
+ (BOOL)jy_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)jy_isValidCharacterOrNumber:(NSString *)str;


@end
