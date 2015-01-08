//
//  CompletedTaskViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/6.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "CompletedTaskViewController.h"
#import "TaskDetailInfoTableViewController.h"

@interface CompletedTaskViewController () {
    NSMutableArray *taskList;
    int currentPage;
    int totalPage;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation CompletedTaskViewController
@synthesize mainTableView;
@synthesize taskListType;
@synthesize titleStr;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = titleStr;
    currentPage = 1;
    totalPage = -1;
    taskList = [NSMutableArray array];
    [self setTableFooterView:self.mainTableView];
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        currentPage = 1;
        [self gainTaskInfo];
    }];
    
    [self gainTaskInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (NSString *)gainHttpAction {
    NSString *action = @"";
    if (taskListType == 7) {
        action = DownEmployeesTaskAction;
    }else if (taskListType == 8) {
        action = NofinishTaskListAction;
    }else if (taskListType == 9) {
        action = FinishTaskListAction;
    }
    return action;
}



// 获取下啦数据
- (void)gainTaskInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"pageNo": [NSString stringWithFormat:@"%d", currentPage],
                                 @"pageSize": [NSString stringWithFormat:@"10"]};

    [self createAsynchronousRequest:[self gainHttpAction] parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithTaskInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        if (currentPage == 1) {
            [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        }else {
            [mainTableView footerEndRefreshing];
        }
        
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowLoading Enabled:YES];
    }];
}


//处理网络操作结果
- (void)dealWithTaskInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];
            
            if (currentPage == 1) {
                taskList = [NSMutableArray arrayWithArray:[[dic objectForKey:[self gainResultTitle]] objectForKey:[self gainRowTitle]]];
            }else {
                for (NSDictionary *taskInfo in [[dic objectForKey:[self gainResultTitle]] objectForKey:[self gainRowTitle]]) {
                    [taskList addObject:taskInfo];
                }
            }
            
            totalPage = [[[dic objectForKey:[self gainResultTitle]] objectForKey:@"totalPages"] intValue];
            self.mainTableView.tableFooterView = [self gainFooterView];
            
            [mainTableView reloadData];
            
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    if (currentPage == 1) {
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }else {
        [mainTableView footerEndRefreshing];
    }
    
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (NSString *)gainResultTitle {
    if (taskListType == 7) {
        return @"downEmployeeTaskInfo";
    }else if (taskListType == 8) {
        return @"nofinishTaskInfo";
    }else if (taskListType == 9) {
        return @"finishTaskInfo";
    }
    return nil;
}

- (NSString *)gainRowTitle {
    if (taskListType == 7) {
        return @"downEmployeeTasks";
    }else if (taskListType == 8) {
        return @"nofinishTasks";
    }else if (taskListType == 9) {
        return @"finishTasks";
    }
    return nil;
}


- (UIView *)gainFooterView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:@"已加载完数据"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [btn addTarget:self  action:@selector(addTaskListWithFootView) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击加载数据" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (totalPage <= currentPage && totalPage != -1) {
        return label;
    }else {
        return btn;
    }
}

- (void)addTaskListWithFootView {
    currentPage ++;
    [self gainTaskInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [taskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"completedTaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *taskInfo = [taskList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [taskInfo objectForKey:@"title"];
    cell.detailTextLabel.text = [taskInfo objectForKey:@"endDate"];
    
    return  cell;
}

#pragma  mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSDictionary *taskInfo = [taskList objectAtIndex:indexPath.row];
    [self gainTaskDetailView:[taskInfo objectForKey:@"taskId"]];
}

- (void)gainTaskDetailView:(NSString *)taskId {
    TaskDetailInfoTableViewController *taskDetailInfoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailInfoTableViewController"];
    taskDetailInfoTableViewController.taskId = taskId;
    [self.navigationController pushViewController:taskDetailInfoTableViewController animated:YES];
}

@end
