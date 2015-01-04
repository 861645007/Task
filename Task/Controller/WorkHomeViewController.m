//
//  WorkHomeViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "WorkHomeViewController.h"
#import "PlistOperation.h"

@interface WorkHomeViewController () {
    NSMutableDictionary *proclamationDic;
    
    int gainPersonInfoNum;
}
@end

@implementation WorkHomeViewController
@synthesize mainTableView;

#pragma mark - 操作

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gainPersonInfoNum = 0;
    proclamationDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lastNoticeContent":@"", @"unreadNoticeCount":@"0", @"lastNoticeId":@"0"}];

    if ([self detectionNetworkStatus]) {
        // 获取信息操作
        [self gainUserBaseInfo];
        
        // 后台多线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self gainAllPersonInfo];
        });
    }else {
        [self createSimpleAlertView:@"暂无网络" msg:@"请您打开手机流量"];
    }
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainUserBaseInfo];
    }];
}

- (BOOL)detectionNetworkStatus {
    if ([[DetectionNetworkStatus checkUpNetworkStatus] isEqualToString:@"0"]) {
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取用户基本信息
- (void)gainUserBaseInfo {
    NSString *userLogInName = [userInfo gainUserLogInName];
    NSString *userLogInPwd = [userInfo gainUserLogInPwd];
    
    //参数
    NSDictionary *parameters = @{@"type": @"IOS", @"username":userLogInName, @"password": userLogInPwd};
    
    [self createAsynchronousRequest:HomeAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithUserBaseInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowPhotoNo Enabled:YES];
    }];
}

//处理网络操作结果
- (void)dealWithUserBaseInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取信息成功" Type:ShowPhotoYes Enabled:YES];
            [self savePersonInfo:[dic objectForKey:@"userInfo"]];
            [self setProclamationInfo:[dic objectForKey:@"noticeInfo"]];

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

- (void)savePersonInfo:(NSDictionary *)dic {
    //保存用户信息
    [userInfo saveUserName:[dic objectForKey:@"realName"]];
    [userInfo saveUserPinyinName:[dic objectForKey:@"pinyinName"]];
    [userInfo saveUserId:[dic objectForKey:@"employeeId"]];
    [userInfo saveUserEnterpriseId:[dic objectForKey:@"enterpriseId"]];
    [userInfo saveUserIconPath:[dic objectForKey:@"image"]];
    [userInfo saveUserAttendace:[dic objectForKey:@"isAttendance"]];
}

- (void)setProclamationInfo:(NSDictionary *)dic {
    proclamationDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [proclamationDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"unreadNoticeCount"]] forKey:@"unreadNoticeCount"];
    [proclamationDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"lastNoticeId"]] forKey:@"lastNoticeId"];
}

#pragma mark - 获取公司所有人员信息
- (void)gainAllPersonInfo {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:AllEmployeesAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainProclamationInfoResult: dic];
    } failure:^{
        if (gainPersonInfoNum < 3) {
            [self gainAllPersonInfo];
            gainPersonInfoNum ++;
        }
    }];
}

//处理网络操作结果
- (void)dealWithGainProclamationInfoResult:(NSDictionary *)dic {

    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            [self gainAllPersonInfo];
            break;
        }
        case 1: {
            [[PlistOperation shareInstance] saveAllPersonInfoToFile:[dic objectForKey:@"employees"]];
            break;
        }
    }
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"ProclamationCell";
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ProclamationTableViewCell *proclamationcell = (ProclamationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        proclamationcell.proclamationUnreadNumberLabel.text = [proclamationDic objectForKey:@"unreadNoticeCount"];
        [proclamationcell.gainToUnReadViewBtn addTarget:self action:@selector(gainToUnReadView) forControlEvents:UIControlEventTouchUpInside];
        [proclamationcell.gainToCurrenProclamationViewBtn addTarget:self action:@selector(gainToCurrenProclamationView) forControlEvents:UIControlEventTouchUpInside];

        if ([[proclamationDic objectForKey:@"lastNoticeId"] isEqualToString:@"0"]) {
            proclamationcell.proclamationTitleLabel.text = @"暂无公告";
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewProclamation)];
            [proclamationcell.taskAddImageView addGestureRecognizer:tapGestureRecognizer];
            
        }else {
            proclamationcell.taskAddImageView.hidden = YES;
            proclamationcell.proclamationTitleLabel.text = [proclamationDic objectForKey:@"lastNoticeContent"];
        }
        
        cell = proclamationcell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)gainToUnReadView {
    ProclamationListViewController *proclamationListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProclamationListViewController"];
    [self.navigationController pushViewController:proclamationListViewController animated:YES];
}

- (void)gainToCurrenProclamationView {
    if (![[proclamationDic objectForKey:@"lastNoticeId"] isEqualToString:@"0"]) {
        //进入当前公告的详细信息界面
        ProclamationDetailInfoViewController *proclamationDetailInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProclamationDetailInfoViewController"];
        proclamationDetailInfoViewController.noticeId = [proclamationDic objectForKey:@"lastNoticeId"];
        [self.navigationController pushViewController:proclamationDetailInfoViewController animated:YES];
    }
}


#pragma mark - 新增公告 proclamation
- (void)addNewProclamation {
    AddNewProclamationViewController *addNewProclamationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewProclamationViewController"];
    addNewProclamationViewController.proclamationContext = @"";
    addNewProclamationViewController.noticeId = @"";
    [self.navigationController pushViewController:addNewProclamationViewController animated:YES];
}

#pragma mark - 菜单操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}
@end
