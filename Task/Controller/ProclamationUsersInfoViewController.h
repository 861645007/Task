//
//  ProclamationUsersInfoViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "ProclamationUsersInfoTableViewCell.h"

@interface ProclamationUsersInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *proclamationUsersInfoArr;

@end
