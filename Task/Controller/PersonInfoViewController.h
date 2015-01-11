//
//  PersonInfoViewController.h
//  Task
//
//  Created by wanghuanqiang on 15/1/3.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectHeaderViewController.h"

@interface PersonInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, SelectedHeaderProtocol>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
