//
//  LeaveViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "LeaveTableViewCell.h"
#import "EditLeaveViewController.h"
#import "LeaveDetailViewController.h"
#import "KxMenu.h"

@interface LeaveViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tableSelectedSegmented;

- (IBAction)showMenu:(id)sender;
- (IBAction)addNewLeave:(id)sender;
- (IBAction)selectedLeaveTableView:(id)sender;

@end
