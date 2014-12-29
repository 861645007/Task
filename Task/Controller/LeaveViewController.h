//
//  LeaveViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "LeaveHomeTableViewCell.h"

@interface LeaveViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

- (IBAction)showMenu:(id)sender;
- (IBAction)addNewLeave:(id)sender;

@end
