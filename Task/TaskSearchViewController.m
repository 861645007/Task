//
//  TaskSearchViewController.m
//  Task
//
//  Created by JackXu on 15/3/21.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "TaskSearchViewController.h"

@interface TaskSearchViewController ()

@end

@implementation TaskSearchViewController{
    NSMutableDictionary *tableVieDataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableVieDataDic = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
}

#pragma mark - 获取数据
// 获取数据
- (void)gainAttendanceInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"userId": employeeId,
                                 @"title":[[NSString alloc]initWithString:self.searchBar.text]
                                 };
    [self createAsynchronousRequest:searchTaskAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainAttendanceInfoResult:dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        // [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowLoading Enabled:YES];
    }];
}

//处理网络操作结果
- (void)dealWithGainAttendanceInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];
            [tableVieDataDic setValue:[dic objectForKey:@"tasks"] forKey:@"tasks"];
            NSLog(@"task00:%@",[tableVieDataDic objectForKey:@"tasks"]);

            [_mainTableView reloadData];
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    [_mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

//开始搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self gainAttendanceInfo];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    NSLog(@"task:%@",[tableVieDataDic objectForKey:@"tasks"] );
    return [[tableVieDataDic objectForKey:@"tasks"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    cellIdentifier = @"STaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *dic = [[tableVieDataDic objectForKey:@"tasks"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"title"];
    int taskType = [[dic objectForKey:@"type"] intValue];
    if (taskType == 0) {
        cell.textLabel.textColor = [UIColor blackColor];
    } else if (taskType == 1) {
        cell.textLabel.textColor = [UIColor orangeColor];
    } else if (taskType == 2) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.detailTextLabel.text = [dic objectForKey:@"endDate"];
    return cell;
    
}

//点击详细任务
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSDictionary *dic = [[tableVieDataDic objectForKey:@"tasks"] objectAtIndex:indexPath.row];
    [self gainTaskDetailView:[dic objectForKey:@"taskId"]];
}

//跳转任务详情页面
- (void)gainTaskDetailView:(NSString *)taskId {
    TaskDetailInfoTableViewController *taskDetailInfoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailInfoTableViewController"];
    taskDetailInfoTableViewController.taskId = taskId;
    [self.navigationController pushViewController:taskDetailInfoTableViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
