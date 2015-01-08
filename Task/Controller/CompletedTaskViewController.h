//
//  CompletedTaskViewController.h
//  Task
//
//  Created by wanghuanqiang on 15/1/6.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface CompletedTaskViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic) int taskListType;                   // 7：下属任务 8：未完成的任务 9：已完成的任务

@end
