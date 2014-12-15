//
//  NSData+ExtensionWithData.h
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ExtensionWithData)

#pragma mark - NSData 转换成 NSString
/**
*  NSData转化成字符串
*
*  @return 符合要求的 NSString
*/
- (NSString *)dataToString;


@end
