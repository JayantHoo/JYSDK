//
//  NSString+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSString+JYExtension.h"

@implementation NSString (JYExtension)

//将html代码字符串中的标签过滤掉
-(instancetype)jy_stringAtHtmlString
{
    //@"<[^>]*>|\n|\t|&[A-Za-z]*;"   <[^>]*>表示匹配<>之间的内容，中间[^>]* 表示过滤>字符n次，  | 表示"或"运算，
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n|\t|&[A-Za-z]*;" options:NSRegularExpressionUseUnixLineSeparators error:nil];
    
    return [regularExpretion stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
}

//手机号码中间替换为****
-(NSString *)jy_securePhoneNumber
{
    NSString *secureNum = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return secureNum;
}

/** 去掉两端空格和换行符 */
- (NSString *)jy_stringByTrimmingBlank
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//提取字符串中的数字
-(NSInteger)jy_numberFromString
{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSInteger remainSecond =[[self stringByTrimmingCharactersInSet:nonDigits] integerValue];
    return remainSecond;
}

@end
