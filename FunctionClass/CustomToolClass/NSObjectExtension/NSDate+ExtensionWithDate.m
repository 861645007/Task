//
//  NSDate+ExtensionWithDate.m
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSDate+ExtensionWithDate.h"

@implementation NSDate (ExtensionWithDate)

// date 转 String
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormatStrring {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatStrring;
    NSString *dateString = [[NSString alloc] init];
    dateString = [dateFormatter stringFromDate: self];
    
    return dateString;
}


// 得到昨天的此时此刻
+ (NSDate *)gainYesterdayDate {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-3600 * 24];
    return yesterday;
}

// 得到明天的此时此刻
+ (NSDate *)gainTomorrowDate {
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:3600 * 24];
    return tomorrow;
}

// 得到 X 天后的此时此刻
+ (NSDate *)gainXDayDate:(int)xDay {
    NSDate *xDayDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * xDay];
    return xDayDate;
}


@end
