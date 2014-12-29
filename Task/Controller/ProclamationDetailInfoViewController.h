//
//  ProclamationDetailInfoViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "AddNewProclamationViewController.h"
#import "ProclamationCommentsViewController.h"
#import "ProclamationUsersInfoViewController.h"
#import "ProclamationListCell.h"

@interface ProclamationDetailInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSString *noticeId;

@end
