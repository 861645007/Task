//
//  NSDictionary+ExtensionWithDictionary.h
//  Task
//
//  Created by wanghuanqiang on 14/12/7.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ExtensionWithDictionary)

#pragma mark - NSDictionary 转换成 NSString
/**
 *  将字符串转化成 dictionary
 *
 *  @return  返回字符串
 */
- (NSString *)dictionaryToString;

@end
