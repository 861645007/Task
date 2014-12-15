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

@end
