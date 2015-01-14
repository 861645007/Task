//
//  LeaveDetailViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LeaveDetailViewController.h"
#import "PreviewFileViewController.h"
#import "AddLeaveAccessaryTableViewCell.h"

@interface LeaveDetailViewController () {
    int leaveApprovesIsShow;            // 0为展开   1已经展开
    NSMutableArray *isShow;
    NSMutableArray *leaveApprovesList;
    NSMutableArray *leaveAccessaryList;
    NSMutableDictionary *leaveDetailInfoDic;
    
    LeaveApprovesTableViewCell *leaveApprovesHeightCell;
}

@end

@implementation LeaveDetailViewController
@synthesize mainTableView;
@synthesize leaveId;
@synthesize leaveEditType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isShow = [NSMutableArray arrayWithArray:@[@"0", @"0"]];
    leaveApprovesList = [NSMutableArray array];
    leaveAccessaryList = [NSMutableArray array];
    leaveDetailInfoDic = [NSMutableDictionary dictionary];
    leaveApprovesHeightCell = [[LeaveApprovesTableViewCell alloc] init];
    [self setTableFooterView:mainTableView];

    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainLeaveDetailInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gainLeaveDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取数据
// 获取数据
- (void)gainLeaveDetailInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"leaveId": leaveId}];

    [self createAsynchronousRequest:LeaveDetailAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainLeaveDerailInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }];
}

//处理网络操作结果
- (void)dealWithGainLeaveDerailInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];
            
            leaveDetailInfoDic = [dic objectForKey:@"leaveInfo"];
            leaveApprovesList = [leaveDetailInfoDic objectForKey:@"leaveApproves"];
            leaveAccessaryList = [leaveDetailInfoDic objectForKey:@"leaveAccessorys"];
            
            // 加载右上角按钮
            if (leaveEditType == 1) {
                UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editLeaveDetail)];
                self.navigationItem.rightBarButtonItem = rightBar;
            }else if (leaveEditType == 2) {
                UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:UIBarButtonItemStylePlain target:self action:@selector(approveLeaveDetail)];
                self.navigationItem.rightBarButtonItem = rightBar;
            }
            
            [mainTableView reloadData];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
}

// 调到 编辑
- (void)editLeaveDetail {
    EditLeaveViewController *editLeaveViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditLeaveViewController"];
    
    NSString *leaveApproveIds = @"";
    NSString *leaveApproveNames = @"";
    
    for (NSDictionary *dic in leaveApprovesList) {
        if ([dic isEqual:[leaveApprovesList lastObject]]) {
            leaveApproveIds = [leaveApproveIds stringByAppendingFormat:@"%@",[dic objectForKey:@"approveId"]];
            leaveApproveNames = [leaveApproveNames stringByAppendingFormat:@"%@",[dic objectForKey:@"approveName"]];
        }else {
            leaveApproveIds = [leaveApproveIds stringByAppendingFormat:@"%@,",[dic objectForKey:@"approveId"]];
            leaveApproveNames = [leaveApproveNames stringByAppendingFormat:@"%@,",[dic objectForKey:@"approveName"]];
        }
    }
    
    editLeaveViewController.isAddNewLeave      = 1;
    editLeaveViewController.titleStr           = @"编辑请假";
    editLeaveViewController.leaveId            = [leaveDetailInfoDic objectForKey:@"leaveId"];
    editLeaveViewController.leaveType          = [leaveDetailInfoDic objectForKey:@"type"];
    editLeaveViewController.leaveApproveIds    = leaveApproveIds;
    editLeaveViewController.leaveApproveNames  = leaveApproveNames;
    editLeaveViewController.leaveContent       = [leaveDetailInfoDic objectForKey:@"comment"];
    editLeaveViewController.leaveEndTime       = [leaveDetailInfoDic objectForKey:@"endTime"];
    editLeaveViewController.leaveStartTime     = [leaveDetailInfoDic objectForKey:@"startTime"];
    editLeaveViewController.leaveAccessaryList = leaveAccessaryList;
    
    [self.navigationController pushViewController:editLeaveViewController animated:YES];
}

// 调到 审核
- (void)approveLeaveDetail {
    NSString *leaveApproveId = @"";
    NSString *myName = [userInfo gainUserName];
    for (NSDictionary *dic in leaveApprovesList) {
        if ([myName isEqualToString:[dic objectForKey:@"approveName"]]) {
            leaveApproveId = [dic objectForKey:@"leaveApproveId"];
            break ;
        }
    }
    
    ApprovesLeaveViewController *approvesLeaveViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ApprovesLeaveViewController"];
    approvesLeaveViewController.leaveId = [leaveDetailInfoDic objectForKey:@"leaveId"];
    approvesLeaveViewController.leaveApproveId = leaveApproveId;
    [self.navigationController pushViewController:approvesLeaveViewController animated:YES];
}

#pragma mark - TableViewDelegate And TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[leaveDetailInfoDic allKeys] count] == 0) {
        return 0;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([[leaveDetailInfoDic allKeys] count] != 0) {
            return 1;
        }
    }else if (section == 1) {
        if ([[isShow objectAtIndex:section - 1] intValue]) {
            if ([leaveAccessaryList count] != 0) {
                return [leaveAccessaryList count];
            }
        }
    }else if (section == 2) {
        if ([[isShow objectAtIndex:section - 1] intValue]) {
            if ([leaveApprovesList count] != 0) {
                return [leaveApprovesList count];
            }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 43;
    }else if (section == 2) {
        return 43;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 44;
    }else if (indexPath.section == 2) {
        return [leaveApprovesHeightCell gainLeaveApprovesCellHeight:[leaveApprovesList objectAtIndex:indexPath.row]];
    }
    return 80;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44)];
        sectionView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f];
        
        // 设置按钮触发点击事件
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        btn.tag = section - 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置 section 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 320, 44)];
        titleLabel.textColor = GrayColorForTitle;
        titleLabel.font = [UIFont systemFontOfSize:17];
        if (section == 1) {
            titleLabel.text = @"附件列表";
        }else if (section == 2) {
            titleLabel.text = @"审批人列表";
        }
        [titleLabel sizeToFit];
        
        UIImageView *pointToImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36, 7, 30, 30)];
        if ([[isShow objectAtIndex:section - 1] intValue]) {
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
    [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag + 1]
                 withRowAnimation:UITableViewRowAnimationFade];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"";
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {        
        cellIdentifier = @"LeaveTableViewCell";
        LeaveTableViewCell *leaveCell = (LeaveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (leaveCell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveTableViewCell" owner:self options:nil];
            leaveCell = [nib objectAtIndex:0];
        }
        
        leaveCell.leaveContentLabel.text = [self judgeTextIsNULL:[leaveDetailInfoDic objectForKey:@"comment"]];
        leaveCell.leavePersonNameLabel.text = [self judgeTextIsNULL:[leaveDetailInfoDic objectForKey:@"leaveUserName"]];
        leaveCell.leaveTimeLabel.text = [self judgeTextIsNULL:[NSString stringWithFormat:@"%@ 至 %@", [leaveDetailInfoDic objectForKey: @"startTime"], [leaveDetailInfoDic objectForKey: @"endTime"]]];
        leaveCell.leaveTypeLabel.text = [self judgeTextIsNULL:[leaveDetailInfoDic objectForKey:@"type"]];
        leaveCell.leaveStateLabel.hidden = YES;
        
        cell = leaveCell;
    }else if (indexPath.section == 1){
        cellIdentifier = @"AddLeaveAccessaryTableViewCell";
        AddLeaveAccessaryTableViewCell *leaveAccessaryCell = (AddLeaveAccessaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (leaveAccessaryCell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddLeaveAccessaryTableViewCell" owner:self options:nil];
            leaveAccessaryCell = [nib objectAtIndex:0];
        }
        
        if (leaveEditType != 1) {
            leaveAccessaryCell.deleteAccessaryBtn.hidden = YES;
        }else {
            [leaveAccessaryCell.deleteAccessaryBtn addTarget:self action:@selector(deleteAccessary:) forControlEvents:UIControlEventTouchUpInside];
            leaveAccessaryCell.deleteAccessaryBtn.tag = indexPath.row;
        }
        
        NSDictionary *dic = [leaveAccessaryList objectAtIndex:indexPath.row];
        leaveAccessaryCell.accessaryNameLabel.text = [dic objectForKey:@"accessoryName"];
        leaveAccessaryCell.accessarySizeLabel.text = [NSString stringWithFormat:@"大小:%@", [dic objectForKey:@"size"]];
        
        cell = leaveAccessaryCell;
    }else if (indexPath.section == 2){
        cellIdentifier = @"LeaveApprovesCell";
        LeaveApprovesTableViewCell *leaveApprovesCell = (LeaveApprovesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (leaveApprovesCell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LeaveApprovesTableViewCell" owner:self options:nil];
            leaveApprovesCell = [nib objectAtIndex:0];
        }
        
        NSDictionary *dic = [leaveApprovesList objectAtIndex:indexPath.row];
        [leaveApprovesCell setLeaveApprovesResult:dic];
        leaveApprovesCell.leaveApprovesNameLabel.text = [dic objectForKey:@"approveName"];
        
        cell = leaveApprovesCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSDictionary *accessAryDic = [leaveAccessaryList objectAtIndex:indexPath.row];
        PreviewFileViewController *previewFileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewFileViewController"];
        previewFileViewController.isTaskOrReportAccessory = 2;
        previewFileViewController.accessoryId = [accessAryDic objectForKey:@"accessoryId"];
        previewFileViewController.fileName = [accessAryDic objectForKey:@"accessoryTempName"];
        [self.navigationController pushViewController:previewFileViewController animated:YES];

    }
}

#pragma mark - 删除附件
- (void)deleteAccessary:(UIButton *)btn {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSDictionary *accessaryDic = [leaveAccessaryList objectAtIndex:btn.tag];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"leaveId": leaveId, @"accessoryId": [accessaryDic objectForKey:@"accessoryId"]}];
    
    [self createAsynchronousRequest:DeleteAccessoryAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithDeleteAccessaryResult: dic index:btn.tag];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }];
}

//处理网络操作结果
- (void)dealWithDeleteAccessaryResult:(NSDictionary *)dic index:(NSInteger)index {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"删除成功" Type:ShowPhotoYes Enabled:YES];
            
            [leaveAccessaryList removeObjectAtIndex:index];
            [self.mainTableView reloadData];
            
            [mainTableView reloadData];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
}

@end
