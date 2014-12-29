//
//  NSString+ExtensionWithString.h
//  TemplateProject
//
//  Created by wanghuanqiang on 14/12/5.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ExtensionWithString)

#pragma mark - NSString 转换成 NSData
/**
*  字符串转化成NSData
*
*  @return 符合要求的NSData
*/
- (NSData *)stringToData;

#pragma mark - NSString 转换成 NSArray
/**
*  字符串转数组
*
*  @param separator 分隔符
*
*  @return 符合格式的数组
*/
- (NSArray *)stringToArrayWithSeparator:(NSString *)separator;

#pragma mark - NSString 转换成 NSDate
/**
 *  字符串转化成时间
 *
 *  @param dateFormatStrring 要转化的时间戳格式 @"yyyy-MM-dd HH:mm:ss.S"
 *
 *  @return 符合格式的时间（NSDate）
 */
- (NSDate *)stringToDateWithFormat:(NSString *)dateFormatStrring;


#pragma mark - 验证手机号码
/**
*  验证手机号码是否为11位
*
*  @return 号码正确：返回 yes;  号码错误：返回 NO;
*/
-(BOOL)validateMobile;

#pragma mark - 给我评分
/**
 *  传入本 app 的 appID ，使用户跳转到 APP 商店进行打分；
 */
- (void)gotoGrade;

#pragma mark - 打开dream网址
/**
 *  通过传入一个 url的字符串，在 Safari 上打开该网址
 */
-(void)openWebURL;

@end
