//
//  WorkHomeViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "WorkHomeViewController.h"

@interface WorkHomeViewController () {
    NSMutableDictionary *proclamationDic;
}
@end

@implementation WorkHomeViewController
@synthesize mainTableView;

#pragma mark - 操作

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    proclamationDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lastNoticeContent":@"", @"unreadNoticeCount":@"0", @"lastNoticeId":@"0"}];

    if ([self detectionNetworkStatus]) {
        // 获取信息操作
        [self gainUserBaseInfo];
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
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
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
            // 事情做完了, 结束刷新动画~~~
            [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            
            [mainTableView reloadData];
            break;
        }
    }
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

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"ProclamationCell";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
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
