//
//  NSDate+ExtensionWithDate.h
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ExtensionWithDate)

#pragma mark - NSDate与NSString的转换
/**
*  时间转化成字符串
*
*  @param dateFormatStrring 要转化的时间戳格式
*
*  @return 符合格式的 NSString
*/
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormatStrring;

/**
 *  得到昨天的此时此刻
 *
 *  @return 返回昨天的日期数据
 */
+ (NSDate *)gainYesterdayDate;


/**
 *  得到明天的此时此刻
 *
 *  @return 返回明天的日期数据
 */
+ (NSDate *)gainTomorrowDate;

/**
 *  得到 X 天后的此时此刻
 *
 *  @param xDay 天数
 *
 *  @return 得到 X 天后的日期数据
 */
+ (NSDate *)gainXDayDate:(int)xDay;

@end
