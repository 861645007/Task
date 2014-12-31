//
//  RelateTaskListViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "RelateTaskTableViewCell.h"

@interface RelateTaskListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *taskId;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
