//
//  NSArray+ExtensionWithArray.h
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ExtensionWithArray)

#pragma mark - NSArray 转化成 NSString
/**
 *  数组转字符串
 *
 *  @param separator 分隔符
 *
 *  @return 返回符合要求的字符串
 */
- (NSString *)arrayToStringWithSeparator:(NSString *)separator;

@end
