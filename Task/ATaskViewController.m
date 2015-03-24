//
//  ATaskViewController.m
//  Task
//
//  Created by JackXu on 15/3/20.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "ATaskViewController.h"

@interface ATaskViewController ()

@end

@implementation ATaskViewController{
    NSMutableDictionary *tableVieDataDic;
    int pageSize;
    NSInteger pageNo;
    NSInteger totalPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableVieDataDic = [NSMutableDictionary dictionary];
    [self gainAttendanceInfo];
    pageNo = 1;
    totalPage = 1;
    [self setNavigationTitle];
    // Do any additional setup after loading the view.
}

-(void)setNavigationTitle{
    NSString *title;
    switch (self.taskType) {
        case 1:
            title = @"我创建的任务";
            break;
        case 2:
            title = @"我负责的任务";
            break;
        case 3:
            title = @"我参与的任务";
            break;
        case 4:
            title = @"我关注的任务";
            break;
        case 5:
            title = @"共享给我的任务";
            break;
        default:
            title = @"任务";
            break;
    }
    NSLog(@"title:%@",title);
    self.navigationItem.title =  title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                 @"type": [[NSString alloc]initWithFormat:@"%d",self.taskType],
                                 @"pageNo":[[NSString alloc]initWithFormat:@"%ld",(long)pageNo],
                                 @"pageSize":[[NSString alloc]initWithFormat:@"%d",pageSize]
                                 };
    [self createAsynchronousRequest:TaskPagerAction parmeters:parameters success:^(NSDictionary *dic){
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
            pageNo = [[dic objectForKey:@"pageNo"]integerValue];
            totalPage = [[dic objectForKey:@"totalPage"]integerValue];
      //      [self setSectionTableVieDataDic:[dic objectForKey:@"homeTask"]];
            NSMutableArray *list = [[NSMutableArray alloc]init];
            NSMutableArray *newlist = [[NSMutableArray alloc]init];
            newlist = [[dic objectForKey:@"tasks"]mutableCopy];
            list = [[tableVieDataDic objectForKey:@"tasks"]mutableCopy];
            if (list==NULL) {
                [tableVieDataDic setValue:newlist forKey:@"tasks"];
            }else{
                [list addObjectsFromArray:newlist];
                [tableVieDataDic setValue:list forKey:@"tasks"];
            }
            [self.MianTableView reloadData];
            
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
  //  [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (totalPage == pageNo) {
        return [[tableVieDataDic objectForKey:@"tasks"] count];
    }
    return [[tableVieDataDic objectForKey:@"tasks"] count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSString *cellIdentifier;
    
   
    if(indexPath.row==[[tableVieDataDic objectForKey:@"tasks"] count]){
        cellIdentifier = @"AMoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }
  
    cellIdentifier = @"ATaskCell";
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
    
    if (indexPath.row == [[tableVieDataDic objectForKey:@"tasks"] count]) {
        [self gainMoreTask:indexPath.section];
    }else{
        NSDictionary *dic = [[tableVieDataDic objectForKey:@"tasks"] objectAtIndex:indexPath.row];
        [self gainTaskDetailView:[dic objectForKey:@"taskId"]];
    }
}

//跳转任务详情页面
- (void)gainTaskDetailView:(NSString *)taskId {
    if ([[[[self tabBarController].viewControllers objectAtIndex:2] tabBarItem].badgeValue isEqualToString:@"1"]) {
        [[[[self tabBarController].viewControllers objectAtIndex:2] tabBarItem] setBadgeValue:nil];
    }
    
    TaskDetailInfoTableViewController *taskDetailInfoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailInfoTableViewController"];
    taskDetailInfoTableViewController.taskId = taskId;
    [self.navigationController pushViewController:taskDetailInfoTableViewController animated:YES];
}


//加载更多
- (void)gainMoreTask:(int)taskType {
    pageNo++;
    [self gainAttendanceInfo];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
