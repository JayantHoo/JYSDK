//
//  NSDateFormatter+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSDateFormatter+JYExtension.h"

@implementation NSDateFormatter (JYExtension)

+ (instancetype)jy_dateFormatter
{
    return [[self alloc] init];
}

+ (instancetype)jy_dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (instancetype)jy_defaultDateFormatter
{
    return [self jy_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
