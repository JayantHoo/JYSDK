//
//  NSDate+JYExtension.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JY_D_MINUTE        60
#define JY_D_HOUR        3600
#define JY_D_DAY        86400
#define JY_D_WEEK        604800
#define JY_D_YEAR        31556926

@interface NSDate (JYExtension)

/**
 //获取未来时间与当前时间的秒差数
 
 @param future 未来时间
 @return 秒差数
 */
+(NSInteger)jy_secondFromFuture:(NSDate *)future;

/**
 *  是否为今天
 */
- (BOOL)jy_isToday;
/**
 *  是否为昨天
 */
- (BOOL)jy_isYesterday;
/**
 *  是否为今年
 */
- (BOOL)jy_isThisYear;
/**
 *  是否本周
 */
- (BOOL) jy_isThisWeek;

/**
 *  星期几
 */
- (NSString *)jy_weekDay;

/**
 *  是否为在相同的周
 */
- (BOOL) jy_isSameWeekWithAnotherDate: (NSDate *)anotherDate;


/**
 *  通过一个时间 固定的时间字符串 "2016/8/10 14:43:45" 返回时间
 *  @param timestamp 固定的时间字符串 "2016/8/10 14:43:45"
 */
+ (instancetype)jy_dateWithTimestamp:(NSString *)timestamp;

/**
 *  返回固定的 当前时间 2016-8-10 14:43:45
 */
+ (NSString *)jy_currentTimestamp;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)jy_dateWithYMD;

/**
 * 格式化日期描述
 */
- (NSString *)jy_formattedDateDescription;

@end
