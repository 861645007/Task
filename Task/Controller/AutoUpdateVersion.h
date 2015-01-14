//
//  AutoUpdateVersion.h
//  Task
//
//  Created by wanghuanqiang on 15/1/14.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoUpdateVersion : NSObject

//  isAutoSelected: 1表示自动； 0表示手动
- (void)checkNewVersion:(UIViewController *)baseViewController isAutoSelected:(int)isAutoSelected;

@end
