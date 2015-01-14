//
//  LeaveViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LeaveViewController.h"

@interface LeaveViewController () {
    int tableViewType;                   // 0 表示请假列表； 1表示审批列表
    NSMutableArray *leaveList;
    int leaveTablePageNo;
    int leaveTotalPageNum;
    
    NSMutableArray *approveLeaveList;
    int approveLeaveTablePageNo;
    int approveLeaveTotalPageNum;
    
    int isNeedRefresh;                   // 0 不需要刷新； 1 需要刷新；
}

@end

@implementation LeaveViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableFooterView:mainTableView];
    leaveList = [NSMutableArray array];
    approveLeaveList = [NSMutableArray array];
    tableViewType = 0;
    leaveTablePageNo = 1;
    leaveTotalPageNum = -1;
    approveLeaveTablePageNo = 1;
    approveLeaveTotalPageNum = -1;

    isNeedRefresh = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIsRefresh:) name:@"refreshLeaveMainView" object:nil];
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainTableViewData];
    }];
}

- (void)setIsRefresh:(NSNotification *)notification {
    isNeedRefresh = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    if (isNeedRefresh) {
        isNeedRefresh = 0;
        [self gainTableViewData];
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
- (void)gainTableViewData {
    if (tableViewType == 0) {
        [self gainLeaveListInfo];
    }else {
        [self gainApproveLeaveListInfo];
    }
}

// 获取数据
- (void)gainLeaveListInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"pageNo": [NSString stringWithFormat:@"%d", leaveTablePageNo],
                                 @"pageSize": @"10"};
    
    [self createAsynchronousRequest:LeaveListAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainLeaveListInfoResult: dic dataType: 0];
    } failure:^{
        [mainTableView reloadData];
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网路错误..." Type:ShowLoading Enabled:YES];
    }];
}

- (void)gainApproveLeaveListInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"pageNo": [NSString stringWithFormat:@"%d", approveLeaveTablePageNo],
                                 @"pageSize": @"10"};
    
    [self createAsynchronousRequest:ApproveListAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainLeaveListInfoResult: dic dataType: 1];
    } failure:^{
        [mainTableView reloadData];
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网路错误..." Type:ShowLoading Enabled:YES];
    }];
}

//处理网络操作结果
- (void)dealWithGainLeaveListInfoResult:(NSDictionary *)dic dataType:(int)dataType {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];
            
            if (dataType == 0) {
                leaveList = [[dic objectForKey:@"leaveInfo"] objectForKey:@"leaveList"];
                leaveTotalPageNum = [[[dic objectForKey:@"leaveInfo"] objectForKey:@"totalPages"] intValue];
                leaveTablePageNo = [[[dic objectForKey:@"leaveInfo"] objectForKey:@"pageNo"] intValue];
                
                if ([approveLeaveList count] == 0) {
                    [self gainApproveLeaveListInfo];
                }
            }else {
                approveLeaveList = [[dic objectForKey:@"approveInfo"] objectForKey:@"approveList"];
                approveLeaveTotalPageNum = [[[dic objectForKey:@"approveInfo"] objectForKey:@"totalPages"] intValue];
                approveLeaveTablePageNo = [[[dic objectForKey:@"approveInfo"] objectForKey:@"pageNo"] intValue];
            }
            self.mainTableView.tableFooterView = [self createFootButton];
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

- (UIView *)createFootButton {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:@"已加载完数据"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [btn addTarget:self  action:@selector(gainTableViewData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击加载数据" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (tableViewType == 0) {
        if (leaveTotalPageNum <= leaveTablePageNo && leaveTotalPageNum != -1) {
            return label;
        }else {
            return btn;
        }
    }else {
        if (approveLeaveTotalPageNum <= approveLeaveTablePageNo && approveLeaveTotalPageNum != -1) {
            return label;
        }else {
            return btn;
        }
    }
}


#pragma mark - TableViewDelegate And TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableViewType == 0) {
        return [leaveList count];
    }else {
        return [approveLeaveList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LeaveTableViewCell";
    LeaveTableViewCell *leaveCell = (LeaveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (leaveCell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveTableViewCell" owner:self options:nil];
        leaveCell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = nil;
    
    if (tableViewType == 0) {
        dic = [leaveList objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"state"] intValue]) {
            leaveCell.leaveStateLabel.text = @"已审批";
            leaveCell.leaveStateLabel.textColor = [UIColor greenColor];
        }else {
            leaveCell.leaveStateLabel.text = @"审批中";
            leaveCell.leaveStateLabel.textColor = [UIColor redColor];
        }
    }else {
        dic = [approveLeaveList objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"isApprove"] intValue]) {
            if ([[dic objectForKey:@"approveResult"] intValue]) {
                leaveCell.leaveStateLabel.text = @"同意";
            }else {
                leaveCell.leaveStateLabel.text = @"不同意";
            }
            leaveCell.leaveStateLabel.textColor = [UIColor greenColor];
        }else {
            leaveCell.leaveStateLabel.text = @"未审批";
            leaveCell.leaveStateLabel.textColor = [UIColor redColor];
        }
    }
    
    leaveCell.leaveContentLabel.text = [self judgeTextIsNULL:[dic objectForKey:@"comment"]];
    leaveCell.leavePersonNameLabel.text = [self judgeTextIsNULL:[dic objectForKey:@"leaveUserName"]];
    leaveCell.leaveTimeLabel.text = [self judgeTextIsNULL:[NSString stringWithFormat:@"%@ 至 %@", [dic objectForKey: @"startTime"], [dic objectForKey: @"endTime"]]];
    leaveCell.leaveTypeLabel.text = [self judgeTextIsNULL:[dic objectForKey:@"type"]];

    
    return leaveCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = nil;
    if (tableViewType == 0) {
        dic = [leaveList objectAtIndex:indexPath.row];
    }else{
        dic = [approveLeaveList objectAtIndex:indexPath.row];
    }
    
    LeaveDetailViewController *leaveDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveDetailViewController"];
    leaveDetailViewController.leaveId = [dic objectForKey:@"leaveId"];
    if (tableViewType == 0) {
        if ([[dic objectForKey:@"state"] intValue]) {
            leaveDetailViewController.leaveEditType = 0;
        }else {
            leaveDetailViewController.leaveEditType = 1;
        }
    }else {
        if ([[dic objectForKey:@"isApprove"] intValue]) {
            leaveDetailViewController.leaveEditType = 0;
        }else {
            leaveDetailViewController.leaveEditType = 2;
        }
    }
    
    [self.navigationController pushViewController:leaveDetailViewController animated:YES];
}

#pragma mark - 新增请假操作
- (IBAction)addNewLeave:(id)sender {
}

#pragma mark - 选择 请假列表 或者 审批列表
- (IBAction)selectedLeaveTableView:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        tableViewType = 0;
    }else {
        tableViewType = 1;
    }
    [mainTableView reloadData];
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}


@end
