//
//  NSDate+ExtensionWithDate.m
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSDate+ExtensionWithDate.h"

@implementation NSDate (ExtensionWithDate)

- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormatStrring {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatStrring;
    NSString *dateString = [[NSString alloc] init];
    dateString = [dateFormatter stringFromDate: self];
    
    return dateString;
}

@end
