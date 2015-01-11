//
//  LeaveViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LeaveViewController.h"

@interface LeaveViewController () {
    NSArray *navArr;
    NSMutableArray *isShow;
    NSArray *leaveHomeSectionArr;
    NSMutableArray *tableViewArr;        // 0 为主页接口； 1 为历史审核；   2为历史请假；
    int sectionType;                     // 0 为主页接口； 1 为历史审核；   2为历史请假；
    
    int isNeedRefresh;                   // 0 不需要刷新； 1 需要刷新；
}

@end

@implementation LeaveViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableFooterView:mainTableView];
    tableViewArr = [NSMutableArray arrayWithArray:@[@{},@{},@{}]];
    sectionType = 0;
    isNeedRefresh = 1;
    leaveHomeSectionArr = @[@"处理中的请假", @"需要我审批的请假", @"新审批的请假"];
    isShow = [NSMutableArray array];
    for (int i = 0; i<[leaveHomeSectionArr count]; i++) {
        [isShow addObject:@"0"];
    }
    
    // 设置导航栏为可点击1
    navArr = @[@"请假主页", @"历史审核", @"历史请假"];
    CusNavigationTitleView *navView = [[CusNavigationTitleView alloc] initWithTitle:@"请假主页" titleStrArr:navArr imageName:@"Expansion"];
    __block CusNavigationTitleView *copyNavView = navView; // 防止陷入“retain cycle” -- “形成怪圈”的错误
    navView.selectRowAtIndex = ^(NSInteger index){
        copyNavView.titleString = navArr[(long)index];
        // 选择标题后刷新界面
        sectionType = index;
        isNeedRefresh = 1;
        [self gainLeaveHomeInfo];
    };
    self.navigationItem.titleView = navView;
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainLeaveHomeInfo];
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    if (isNeedRefresh) {
        isNeedRefresh = 0;
        [self gainLeaveHomeInfo];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GainToDetailInfo"]) {
        EditLeaveViewController *editLeaveViewController = [segue destinationViewController];
        editLeaveViewController.isAddNewLeave = 0;
        editLeaveViewController.titleStr = @"新增请假";
    }
}

#pragma mark - 获取数据
// 获取数据
- (void)gainLeaveHomeInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId}];
    NSString *action = @"";
    
    if (sectionType == 0) {
        action = LeaveHomeAction;
    }else if (sectionType == 1) {
        action = LeaveHistoryAction;
    }else {
        action = LeaveHistoryApproveAction;
    }
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainLeaveHomeInfoResult: dic];
    } failure:^{
        [mainTableView reloadData];
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网路错误..." Type:ShowLoading Enabled:YES];
    }];
}

//处理网络操作结果
- (void)dealWithGainLeaveHomeInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];

            if (sectionType == 0) {
                sectionType = 0;
                NSDictionary *leaveInfoDic = [dic objectForKey:@"leaveInfo"];
                NSDictionary *leaveHomeDic = @{@"处理中的请假": [leaveInfoDic objectForKey:@"processingLeaves"],  @"需要我审批的请假": [leaveInfoDic objectForKey:@"approveingLeaves"] , @"新审批的请假": [leaveInfoDic objectForKey:@"newProcessLeaves"]};
                tableViewArr[0] = leaveHomeDic;
            } else if (sectionType == 1) {
                sectionType = 1;
                tableViewArr[1] = [dic objectForKey:@"historyLeaveList"];
            } else if (sectionType == 2) {
                sectionType = 2;
                tableViewArr[2] = [dic objectForKey:@"historyApproveList"];
            }
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    [mainTableView reloadData];
}


#pragma mark - TableViewDelegate And TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (sectionType == 0) {
        return [leaveHomeSectionArr count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (sectionType == 0) {
        if ([[isShow objectAtIndex:section] intValue]) {
            NSString *key = [leaveHomeSectionArr objectAtIndex:section];
            if (![[tableViewArr objectAtIndex:sectionType] isEqual: @{}]) {
                return [[[tableViewArr objectAtIndex:sectionType] objectForKey:key] count];
            }
        }
    } else if (sectionType == 1) {
        if ([tableViewArr[1] count] != 0) {
            return [tableViewArr[1] count];
        }
    } else if (sectionType == 2) {
        if ([tableViewArr[2] count] != 0) {
            return [tableViewArr[2] count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (sectionType == 0) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (sectionType == 0) {
        return 2;
    }
    return 0;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (sectionType == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44)];
        sectionView.backgroundColor = [UIColor whiteColor];
        NSString *key = [leaveHomeSectionArr objectAtIndex:section];
        
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
        
        UIImageView *pointToImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36, 7, 30, 30)];
        if ([[isShow objectAtIndex:btn.tag] intValue]) {
            [pointToImageView setImage:[UIImage imageNamed:@"Pulldown"]];
        }else {
            [pointToImageView setImage:[UIImage imageNamed:@"pullback"]];
        }
        
        [sectionView addSubview:btn];
        [sectionView addSubview:titleLabel];
        [sectionView addSubview:pointToImageView]; 
        
        return sectionView;
    }
    
    return nil;
}

// 点击 section 后的触发事件
- (void)btnClick:(UIButton *)btn
{
    if ([[isShow objectAtIndex:btn.tag] intValue]) {
        isShow[btn.tag] = @"0";
    }
    else {
        isShow[btn.tag] = @"1";
    }
    // 刷新点击的组标题，动画使用卡片
    [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag]
                 withRowAnimation:UITableViewRowAnimationFade];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LeaveHomeCell";
    LeaveHomeTableViewCell *cell = (LeaveHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveHomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = nil;
    if (sectionType == 0) {
        NSString *sectionTitle = [leaveHomeSectionArr objectAtIndex:indexPath.section];
        dic = [[[tableViewArr objectAtIndex:sectionType] objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    }else {
        dic = [tableViewArr[sectionType] objectAtIndex:indexPath.row];
    }

    cell.leaveNameLabel.text = [dic objectForKey:@"leaveUserName"];
    cell.leaveTypeLabel.text = [dic objectForKey:@"type"];
    cell.leaveContentLabel.text = [dic objectForKey:@"comment"];
    cell.leaveTimeLabel.text = [NSString stringWithFormat:@"%@至%@", [dic objectForKey:@"startTime"], [dic objectForKey:@"endTime"]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = nil;
    if (sectionType == 0) {
        NSString *sectionTitle = [leaveHomeSectionArr objectAtIndex:indexPath.section];
        dic = [[[tableViewArr objectAtIndex:sectionType] objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    }else{
        dic = [tableViewArr[sectionType] objectAtIndex:indexPath.row];
    }
    
    LeaveDetailViewController *leaveDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveDetailViewController"];
    leaveDetailViewController.leaveId = [dic objectForKey:@"leaveId"];
    if (sectionType == 0) {
        if (indexPath.section == 0) {
            leaveDetailViewController.leaveEditType = 1;
        }else if (indexPath.section == 1) {
            leaveDetailViewController.leaveEditType = 2;
        }else {
            leaveDetailViewController.leaveEditType = 0;
        }
    }else {
        leaveDetailViewController.leaveEditType = 0;
    }
    
    [self.navigationController pushViewController:leaveDetailViewController animated:YES];
}

#pragma mark - 新增请假操作
- (IBAction)addNewLeave:(id)sender {
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}


@end
