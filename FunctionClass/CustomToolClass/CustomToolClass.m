//
//  CustomToolClass.m
//  MyPrivacy
//
//  Created by 枫叶 on 14-5-29.
//  Copyright (c) 2014年 skywang1994_枫叶. All rights reserved.
//

#import "CustomToolClass.h"

@implementation CustomToolClass
static CustomToolClass *instnce;

#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

#pragma mark - 在Documents文件夹下的操作子文件夹
/*
 方法：在Documents文件夹下创建子文件夹
 */
- (void)createFolderInDocuments:(NSString *)folderName
{
    NSString *path = [[self gainDocumentsPath] stringByAppendingPathComponent:folderName];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
}

/*
 方法：判断在Documents文件夹下是否存在指定文件夹
 */
- (BOOL)theFolderIsExits:(NSString *)folderName {
    NSString *path = [[self gainDocumentsPath] stringByAppendingPathComponent:folderName];
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return isDirExist;
}

/*
 方法：删除指定文件夹下的所有文件
 */
- (void)removeFileInTheFolder:(NSString *)folderName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[self gainDocumentsPath] stringByAppendingPathComponent:folderName];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}

#pragma mark - 保存文件
//获取沙盒的documents文件夹路径
- (NSString *)gainDocumentsPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

// 获取指定文件夹路径
- (NSString *)gainTheFolderName:(NSString *)folderName {
    NSString *path = @"";
    if (![folderName isEqualToString:@""] || folderName != nil) {
        path = [[self gainDocumentsPath] stringByAppendingFormat:@"/%@", folderName];
    }
    return path;
}

// 获取指定文件路径
- (NSString *)gainFilePath:(NSString *)plistFileName folderName:(NSString *)folderName {
    return [[self gainTheFolderName:folderName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistFileName]];
}

// 从指定文件中保存数据
- (void)saveDataToPlist:(id)dataList plistFileName:(NSString *)plistFileName folderName:(NSString *)folderName {
    NSString *plistPath = [self gainFilePath:plistFileName folderName:folderName];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:plistPath] == NO) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    
    /*存文件*/
    if (dataList) {
        [dataList writeToFile:plistPath atomically:YES];
    }
}

- (id)getDataFromPlist:(NSString *)plistFileName folderName:(NSString *)folderName {
    id fileData = [[NSArray alloc] initWithContentsOfFile:[self gainFilePath:plistFileName folderName:folderName]];
    return fileData;
}



@end
