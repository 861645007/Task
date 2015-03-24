//
//  ATaskViewController.h
//  Task
//
//  Created by JackXu on 15/3/20.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskDetailInfoTableViewController.h"

@interface ATaskViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *MianTableView;

@property int taskType;
@property int page;
@end
