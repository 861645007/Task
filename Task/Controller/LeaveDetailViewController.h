//
//  LeaveDetailViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "LeaveHomeTableViewCell.h"
#import "LeaveApprovesTableViewCell.h"
#import "EditLeaveViewController.h"
#import "ApprovesLeaveViewController.h"

@interface LeaveDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, copy) NSString *leaveId;
@property (nonatomic) int leaveEditType;          // 0表示不可修改不可审批的请假  1表示可修改的请假  2表示可审批的请假

@end
