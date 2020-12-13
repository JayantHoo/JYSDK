//
//  NSDateFormatter+JYExtension.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JYExtension)

+ (instancetype)jy_dateFormatter;

+ (instancetype)jy_dateFormatterWithFormat:(NSString *)dateFormat;

+ (instancetype)jy_defaultDateFormatter;/*yyyy/MM/dd HH:mm:ss*/

@end
