//
//  SubTaskTableViewController.h
//  Task
//
//  Created by wanghuanqiang on 15/1/1.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTaskTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *subTaskList;
@property (nonatomic, strong) NSString *superTaskId;

@end
