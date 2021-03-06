//
//  TaskViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskViewController.h"
#import "CompletedTaskViewController.h"

@interface TaskViewController (){
    NSArray *navArr;
    NSArray *sectionArr;
    NSMutableArray *isShow;
    NSMutableDictionary *tableVieDataDic;
    
    NSString *titleCMD;
    int isNeedRefresh;                   // 0 不需要刷新； 1 需要刷新；
}

@end

@implementation TaskViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置 tableView
    sectionArr = @[@"逾期的任务", @"我创建的任务", @"我负责的任务",@"我参与的任务", @"我关注的任务", @"共享给我的任务", @"未读的任务"];//@"下属任务"
    isShow = [NSMutableArray array];
    for (int i = 0; i<[sectionArr count]; i++) {
        [isShow addObject:@"0"];
    }
    tableVieDataDic = [NSMutableDictionary dictionary];
    titleCMD = @"0";
    isNeedRefresh = 1;
    
    // 设置导航栏为可点击1
   // navArr = @[@"逾期的任务", @"我创建的任务", @"我负责的任务",@"我参与的任务", @"我关注的任务", @"共享给我的任务", @"未读的任务", @"下属任务"];
  //  CusNavigationTitleView *navView = [[CusNavigationTitleView alloc] initWithTitle:@"我的任务" titleStrArr:navArr imageName:@"Expansion"];
 //   __block CusNavigationTitleView *copyNavView = navView; // 防止陷入“retain cycle” -- “形成怪圈”的错误
  //  navView.selectRowAtIndex = ^(NSInteger index){
//        if (index < 7) {
//            copyNavView.titleString = navArr[(long)index];
//            titleCMD = [NSString stringWithFormat:@"%ld", (long)index];
//            // 选择标题后刷新界面
//            [self gainAttendanceInfo];
//        }else  {
//            CompletedTaskViewController *completedTaskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompletedTaskViewController"];
//            completedTaskViewController.titleStr = navArr[(long)index];
//            completedTaskViewController.taskListType = index;
//            [self.navigationController pushViewController:completedTaskViewController animated:YES];
//        }
//    };
//    self.navigationItem.titleView = navView;
    self.navigationItem.title = @"我的任务";

    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainAttendanceInfo];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIsRefresh:) name:@"refreshTaskMainView" object:nil];
    
    // 接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithNotifition:) name:@"TaskSystemNotification" object:nil];
}

- (void)setIsRefresh:(NSNotification *)notification {
    isNeedRefresh = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    if (isNeedRefresh) {
        isNeedRefresh = 0;
        [self gainAttendanceInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 接受通知数据
- (void)dealWithNotifition:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification object];
    
    [self gainTaskDetailView:[notificationInfo objectForKey:@"notificationInfoStr"]];
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
                                 @"userId": employeeId};
    
    [self createAsynchronousRequest:TaskHomeAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainAttendanceInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
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

            [self setSectionTableVieDataDic:[dic objectForKey:@"homeTask"]];
            
            [mainTableView reloadData];
            
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)setSectionTableVieDataDic:(NSDictionary *)dic {
    [tableVieDataDic setObject:[dic objectForKey:@"delayTasks"] forKey:@"逾期的任务"];
    [tableVieDataDic setObject:[dic objectForKey:@"createTasks"] forKey:@"我创建的任务"];
    [tableVieDataDic setObject:[dic objectForKey:@"leaderTasks"] forKey:@"我负责的任务"];
    [tableVieDataDic setObject:[dic objectForKey:@"joinTasks"] forKey:@"我参与的任务"];
    [tableVieDataDic setObject:[dic objectForKey:@"attentionTasks"] forKey:@"我关注的任务"];
    [tableVieDataDic setObject:[dic objectForKey:@"sharedTasks"] forKey:@"共享给我的任务"];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *keys = [sectionArr objectAtIndex:section];
    if ([[isShow objectAtIndex:section] intValue]) {
        if (section>0&&section<6) {
            return [[tableVieDataDic objectForKey:keys] count]+1;
        }else{
            return [[tableVieDataDic objectForKey:keys] count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44)];
    sectionView.backgroundColor = [UIColor whiteColor];
    NSString *key = [sectionArr objectAtIndex:section];
    
    // 设置按钮触发点击事件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    btn.tag = section;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置 section 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 320, 44)];
    titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = key;
    [titleLabel sizeToFit];
    
    // 设置图标
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 7, 30, 21)];
    numberLabel.tag = 200;
    numberLabel.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
    numberLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *gainToAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 9, 25, 25)];
    gainToAddBtn.tag = section;
    [gainToAddBtn addTarget:self action:@selector(addNewTask:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[isShow objectAtIndex:btn.tag] intValue] == 0) {
        numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[tableVieDataDic objectForKey:key] count]];
        gainToAddBtn.hidden = true;
    }else {
        [gainToAddBtn setImage:[UIImage imageNamed:@"Task_Add"] forState:UIControlStateNormal];
        numberLabel.text = [NSString stringWithFormat:@"%d", 0];
        numberLabel.hidden = true;
    }
    
    [sectionView addSubview:numberLabel];
    [sectionView addSubview:titleLabel];
    [sectionView addSubview:btn];
    if (section != 0) {
        [sectionView addSubview:gainToAddBtn];
    }
    
    return sectionView;
}

// 添加新的任务
- (void)addNewTask:(UIButton *)btn {
    AddNewTaskViewController *addNewTaskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTaskViewController"];
    addNewTaskViewController.taskId = @"";
    if (btn.tag == 1) {
        addNewTaskViewController.taskEndTimeStr = [[NSDate date] dateToStringWithDateFormat:@"yyyy-MM-dd"];
    }else if (btn.tag == 2) {
        addNewTaskViewController.taskEndTimeStr = [[NSDate gainTomorrowDate] dateToStringWithDateFormat:@"yyyy-MM-dd"];
    }else if (btn.tag == 3) {
        addNewTaskViewController.taskEndTimeStr = [[NSDate gainXDayDate:7] dateToStringWithDateFormat:@"yyyy-MM-dd"];
    }else {
        addNewTaskViewController.taskEndTimeStr = @"";
    }
    
    [self.navigationController pushViewController:addNewTaskViewController animated:true];
}

// 点击 section 后的触发事件
- (void)btnClick:(UIButton *)btn
{
    if ([[isShow objectAtIndex:btn.tag] intValue] == 0) {
        isShow[btn.tag] = @"1";
    }
    else {
        isShow[btn.tag] = @"0";
    }
    // 刷新点击的组标题，动画使用卡片
    [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag]
                 withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [sectionArr objectAtIndex:indexPath.section];
    NSString *cellIdentifier;
    if(indexPath.row==[[tableVieDataDic objectForKey:sectionTitle] count]){
        cellIdentifier = @"MoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }
    

    
    cellIdentifier = @"MyTaskCell";
    MyTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dic = [[tableVieDataDic objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    
    cell.title.text = [dic objectForKey:@"title"];
    int taskType = [[dic objectForKey:@"type"] intValue];
    if (taskType == 0) {
        cell.title.textColor = [UIColor blackColor];
    } else if (taskType == 1) {
        cell.title.textColor = [UIColor orangeColor];
    } else if (taskType == 2) {
        cell.title.textColor = [UIColor redColor];
    }
    if ([dic objectForKey:@"noReadCount"] == 0) {
        cell.number.hidden = YES;
    }else{
        cell.number.text = [[NSString alloc]initWithFormat:@"%@",[dic objectForKey:@"noReadCount"]];
    }
    cell.detail.text = [dic objectForKey:@"endDate"];
    return cell;
}

// 截图时间
- (NSString *)setFirstTextTime:(NSString *)timeStr {
    NSArray *timeArr = [timeStr componentsSeparatedByString:@" "];
    return timeArr[0];
}

//点击详细任务
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSString *sectionTitle = [sectionArr objectAtIndex:indexPath.section];
    
    if (indexPath.row == [[tableVieDataDic objectForKey:sectionTitle] count]) {
        NSLog(@"more");
       [self gainATasklView:indexPath.section];
    }else{
        NSDictionary *dic = [[tableVieDataDic objectForKey:sectionTitle] objectAtIndex:indexPath.row];
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


//跳转指定任务列表页面
- (void)gainATasklView:(int)taskType {
    ATaskViewController *aTaskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ATaskTableViewController"];
    aTaskViewController.taskType = taskType;
    [self.navigationController pushViewController:aTaskViewController animated:YES];
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}
@end
