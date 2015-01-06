//
//  PlistOperation.h
//  GradeAnalysis
//
//  Created by 枫叶 on 14-6-16.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistOperation : NSObject

+ (id)shareInstance;

/*
 方法：保存NSArray类型数据到plist文件
 参数介绍：
 dataArr：需要保存的array类型数据；
 */
- (void)saveDataToPlist:(NSArray *)dataArr;

/*
 方法：读取plist文件的array类型数据
 参数介绍：
 无
 */
- (NSArray *)getDataFromPlist;

@end
