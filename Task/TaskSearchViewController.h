//
//  TaskSearchViewController.h
//  Task
//
//  Created by JackXu on 15/3/21.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskDetailInfoTableViewController.h"

@interface TaskSearchViewController : BaseViewController<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
