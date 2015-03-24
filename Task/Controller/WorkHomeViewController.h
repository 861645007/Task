//
//  WorkHomeViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "DetectionNetworkStatus.h"
#import "ProclamationTableViewCell.h"
#import "ProclamationListViewController.h"
#import "AddNewProclamationViewController.h"
#import "GonggaoTableViewCell.h"


@interface WorkHomeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)newNotice:(id)sender;


- (IBAction)showMenu:(id)sender;
@end
