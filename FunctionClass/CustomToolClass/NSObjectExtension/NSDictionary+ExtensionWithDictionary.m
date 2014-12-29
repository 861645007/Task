//
//  NSDictionary+ExtensionWithDictionary.m
//  Task
//
//  Created by wanghuanqiang on 14/12/7.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSDictionary+ExtensionWithDictionary.h"

@implementation NSDictionary (ExtensionWithDictionary)

- (NSString *)dictionaryToString {
//    NSError *parseError = nil;
//    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
//    
//    if (parseError != nil) {
//        return @"";
//    }
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSArray *keys = [self allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i < [keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        NSString *value = [self objectForKey:name];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

@end
