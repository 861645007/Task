//
//  NSData+ExtensionWithData.m
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSData+ExtensionWithData.h"

@implementation NSData (ExtensionWithData)

// NSData 转换成 NSString
- (NSString *)dataToString {
    NSString *result = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return result;
}

@end
