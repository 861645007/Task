//
//  PlistOperation.m
//  GradeAnalysis
//
//  Created by 枫叶 on 14-6-16.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "PlistOperation.h"

@implementation PlistOperation


#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
static PlistOperation *instnce;

+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

- (NSString *)getDocumentsPath
{
    //获取沙盒的documents文件夹路径
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveDataToPlist:(NSArray *)dataArr
{
    NSString *plistPath = [[self getDocumentsPath] stringByAppendingPathComponent:@"StudentInfo.plist"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:plistPath] == NO) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    
    /*存文件*/
    if (dataArr) {
        [dataArr writeToFile:plistPath atomically:YES];
    }
}

- (NSArray *)getDataFromPlist
{
    NSString *plistPath = [[self getDocumentsPath] stringByAppendingPathComponent:@"StudentInfo.plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    return array;
}

@end
