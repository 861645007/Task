//
//  ProclamationListViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "ProclamationListCell.h"
#import "ProclamationDetailInfoViewController.h"

@interface ProclamationListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
