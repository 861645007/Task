//
//  TaskViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "AddNewTaskViewController.h"
#import "TaskDetailInfoTableViewController.h"
#import "ATaskViewController.h"
#import "MyTaskTableViewCell.h"

@interface TaskViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


- (IBAction)showMenu:(id)sender;

@end
