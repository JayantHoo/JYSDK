//
//  NSDate+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSDate+JYExtension.h"
#import "NSDateFormatter+JYExtension.h"

#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (JYExtension)

/**
 //获取未来时间与当前时间的秒差数
 
 @param future 未来时间
 @return 秒差数
 */
+(NSInteger)jy_secondFromFuture:(NSDate *)future
{
    return ([future timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970]);
}

/**
 *  是否为今天
 */
- (BOOL)jy_isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)jy_isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] jy_dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self jy_dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)jy_dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


/**
 *  是否为今年
 */
- (BOOL)jy_isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}


// This hard codes the assumption that a week is 7 days
- (BOOL) jy_isSameWeekWithAnotherDate: (NSDate *)anotherDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:anotherDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:anotherDate]) < JY_D_WEEK);
}

/**
 *  星期几
 */
- (NSString *)jy_weekDay
{
    NSArray *weekDays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    //    NSLog(@"NSCalendarUnitWeekday--  components.weekday = %zd  -- components.weekdayOrdinal = %zd  -- components.weekOfYear = %zd  -- components.weekOfMonth = %zd",components.weekday , components.weekdayOrdinal , components.weekOfYear , components.weekOfMonth);
    
    return weekDays[components.weekday - 1];
}



- (BOOL) jy_isThisWeek
{
    return [self jy_isSameWeekWithAnotherDate:[NSDate date]];
}


/**
 *  通过一个时间 固定的时间字符串 "2016/8/10 14:43:45" 返回时间
 *
 *  @param timestamp 固定的时间字符串 "2016/8/10 14:43:45"
 *
 *  @return 时间
 */
+ (instancetype)jy_dateWithTimestamp:(NSString *)timestamp
{
    return [[NSDateFormatter jy_defaultDateFormatter] dateFromString:timestamp];
}


/**
 *  返回固定的 当前时间 2016-8-10 14:43:45
 */
+ (NSString *)jy_currentTimestamp
{
    return [[NSDateFormatter jy_defaultDateFormatter] stringFromDate:[NSDate date]];
}

/**
 * 格式化日期描述
 */
- (NSString *)jy_formattedDateDescription
{
    NSDateFormatter *dateFormatter = nil;
    NSString *result = nil;
    
    if ([self jy_isThisYear])
    {
        // 今年
        if ([self jy_isToday]) {
            // 手机当前时间
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:self toDate:nowDate options:0];

            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 分钟
                return @"刚刚";
            }
            // 22:22
            dateFormatter = [NSDateFormatter jy_dateFormatterWithFormat:@"HH:mm"];
        }else if ([self jy_isYesterday]){
            // 昨天 22:22
            dateFormatter = [NSDateFormatter jy_dateFormatterWithFormat:@"昨天 HH:mm"];
        }else if ([self jy_isThisWeek]){
            // 星期二 22:22
            dateFormatter = [NSDateFormatter jy_dateFormatterWithFormat:[NSString stringWithFormat:@"%@ HH:mm" , [self jy_weekDay]]];
        }else{
            // 2016年08月18日 22:22
            dateFormatter = [NSDateFormatter jy_dateFormatterWithFormat:@"yyyy年MM月dd日 HH:mm"];
        }
        
    }else{
        // 非今年
        dateFormatter = [NSDateFormatter jy_dateFormatterWithFormat:@"yyyy年MM月dd日"];
    }
    
    result = [dateFormatter stringFromDate:self];
    
    return result;
}



@end
