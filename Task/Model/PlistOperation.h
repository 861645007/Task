//
//  PlistOperation.h
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomToolClass.h"
#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "BaseViewController.h"

@interface PlistOperation : NSObject

+ (id)shareInstance;

/**
 *  保存公司所有员工的信息
 *
 *  @param personList 公司所有员工的信息数组（未处理）
 */
- (void)saveAllPersonInfoToFile:(NSArray *)personList;

/**
 *  获取公司所有员工的信息
 *
 *  @return 公司所有员工的信息
 */
- (NSArray *)gainAllPersonInfoWithFile;

/**
 *  获取员工头像
 *
 *  @param imageName 头像名称
 *
 *  @return 返回 UIImage
 */
- (UIImage *)gainPersonImage:(NSString *)imageName;

@end
