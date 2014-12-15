//
//  NSArray+ExtensionWithArray.m
//  Task
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSArray+ExtensionWithArray.h"

@implementation NSArray (ExtensionWithArray)

- (NSString *)arrayToStringWithSeparator:(NSString *)separator {
    NSString *arrString = [NSString string];
    
    for (NSString *stringInArr in self) {
        if ([stringInArr isEqualToString:[self lastObject]]) {
            arrString = [arrString stringByAppendingFormat:@"%@",stringInArr];
        }
        else
        {
            arrString = [arrString stringByAppendingFormat:@"%@%@",stringInArr,separator];
        }
    }
    return arrString;
}

@end
