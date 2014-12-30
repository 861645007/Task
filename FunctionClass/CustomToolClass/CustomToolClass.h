//
//  CustomToolClass.h
//  MyPrivacy
//
//  Created by 枫叶 on 14-5-29.
//  Copyright (c) 2014年 skywang1994_枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomToolClass : NSObject
#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
/*
 方法：外部文件可以直接访问CustomToolClass内部函数
 */
+ (id)shareInstance;

#pragma mark - 在Documents文件夹下创建子文件夹
/**
 *  在Documents文件夹下创建子文件夹
 *
 *  @param folderName 文件夹名称
 */
- (void)createFolderInDocuments:(NSString *)folderName;

/**
 *  判断在Documents文件夹下是否存在指定文件夹
 *
 *  @param folderName 文件夹名称
 *
 *  @return YES：存在； NO：不存在
 */
- (BOOL)theFolderIsExits:(NSString *)folderName;

/**
 *  删除指定文件夹下的所有文件
 *
 *  @param folderName 文件夹名称
 */
- (void)removeFileInTheFolder:(NSString *)folderName;

#pragma mark - 保存文件
/**
 *  从指定文件中保存数据
 *
 *  @param dataList      数据源
 *  @param plistFileName 文件名称
 *  @param folderName    文件夹名称
 */
- (void)saveDataToPlist:(id)dataList plistFileName:(NSString *)plistFileName folderName:(NSString *)folderName;

/**
 *  从指定文件中获取数据
 *
 *  @param plistFileName 文件名称
 *  @param folderName    文件夹名称
 *
 *  @return 文件中数据
 */
- (id)getDataFromPlist:(NSString *)plistFileName folderName:(NSString *)folderName;

@end
