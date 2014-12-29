//
//  NSString+ExtensionWithString.m
//  TemplateProject
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "NSString+ExtensionWithString.h"

@implementation NSString (ExtensionWithString)

// NSString 转换成 NSData

- (NSData *)stringToData {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

// NSString 转换成 NSArray
- (NSArray *)stringToArrayWithSeparator:(NSString *)separator {
    NSArray *array = [NSArray array];
    array = [self componentsSeparatedByString:separator];
    return array;
}

// NSString 转换成 NSDate
- (NSDate *)stringToDateWithFormat:(NSString *)dateFormatStrring {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatStrring;
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString: self];
    
    return date;
}

// 验证手机号码
-(BOOL)validateMobile {
    NSString *mobileStr = @"^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$";
    NSPredicate *cateMobileStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileStr];
    
    if ([cateMobileStr evaluateWithObject: self] == YES)
    {
        return YES;
    }
    return NO;
}

// 给我评分
- (void)gotoGrade {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self];
    [str openWebURL];
}

// 打开dream网址
-(void)openWebURL {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self]];

}


@end
