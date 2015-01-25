//
//  WorkHomeViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "WorkHomeViewController.h"
#import "PlistOperation.h"
#import "AutoUpdateVersion.h"
#import "APService.h"

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
    proclamationDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lastNoticeContent":@"", @"unreadNoticeCount":@"", @"lastNoticeId":@""}];

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

    // 接受自定义通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithNotifition:) name:@"systemNotification" object:nil];
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

#pragma mark - 接受通知数据
- (void)dealWithNotifition:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification object];
    NSLog(@"进入主页推送调用接口%@", [NSDate date]);
    // 判断 app 是否处于前端
    NSString *applicationState = [notificationInfo objectForKey:@"ApplicationState"];
    if ([applicationState intValue] != 0) {

        int page = [[notificationInfo objectForKey:@"badgePage"] intValue];
        if (page == 0) {
            [self gainToNewNoticeDetail:[notificationInfo objectForKey:@"notificationInfoStr"]];
        }else if (page == 2) {
            NSLog(@"进入任务选择界面：%@",[NSDate date]);
            [self tabBarController].selectedViewController = [[self tabBarController].viewControllers objectAtIndex:2];
            [self performSelector:@selector(postNotification:) withObject:notificationInfo afterDelay:0.02];
        }else if (page == 3 || page == 4) {
            [self tabBarController].selectedViewController = [[self tabBarController].viewControllers objectAtIndex:3];
            [self performSelector:@selector(postNotification:) withObject:notificationInfo afterDelay:0.02];
        }
    }else {
        if ([[notificationInfo objectForKey:@"badgePage"] intValue] != -1) {
            [self setTabBarBadgeValue:[notificationInfo objectForKey:@"badgePage"] badgeValue:@"1"];
        }
    }
}

- (void)postNotification:(NSDictionary *)dic {
    if ([[dic objectForKey:@"badgePage"] intValue] == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskSystemNotification" object:dic];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeaveSystemNotification" object:dic];
    }
    
}

// 设置
- (void)setTabBarBadgeValue:(NSString *)tabIndex badgeValue:(NSString *)badgeValue {
    [[[[self tabBarController].viewControllers objectAtIndex:[tabIndex intValue]] tabBarItem] setBadgeValue:badgeValue];
}

// 跳转到 公告详情
- (void)gainToNewNoticeDetail:(NSString *)noticeId {
    if ([[[[self tabBarController].viewControllers objectAtIndex:0] tabBarItem].badgeValue isEqualToString:@"1"]) {
        [self setTabBarBadgeValue:@"0" badgeValue:nil];
    }
    
    ProclamationDetailInfoViewController *proclamationDetailInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProclamationDetailInfoViewController"];
    proclamationDetailInfoViewController.noticeId = noticeId;
    [self.navigationController pushViewController:proclamationDetailInfoViewController animated:YES];
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
    
    // 注册用户 通知 的信息 tag and id
    [APService setTags:[NSSet setWithObjects:[NSString stringWithFormat:@"%@", [dic objectForKey:@"enterpriseId"]], nil] alias:[NSString stringWithFormat:@"%@", [dic objectForKey:@"employeeId"]] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//    NSLog(@"registrationID:%@", [APService registrationID]);
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     tags, alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (void)setProclamationInfo:(NSDictionary *)dic {
    proclamationDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [proclamationDic setValue:[NSString stringWithFormat:@"%@",[self judgeTextIsNULL:[dic objectForKey:@"unreadNoticeCount"]]] forKey:@"unreadNoticeCount"];
    [proclamationDic setValue:[NSString stringWithFormat:@"%@",[self judgeTextIsNULL:[dic objectForKey:@"lastNoticeContent"]]] forKey:@"lastNoticeContent"];
    [proclamationDic setValue:[NSString stringWithFormat:@"%@",[self judgeTextIsNULL:[dic objectForKey:@"lastNoticeId"]]] forKey:@"lastNoticeId"];
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
            if (gainPersonInfoNum < 3) {
                [self gainAllPersonInfo];
                gainPersonInfoNum ++;
            }
            break;
        }
        case 1: {
            [[AutoUpdateVersion alloc] checkNewVersion:self isAutoSelected:1];
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

        if ([[proclamationDic objectForKey:@"unreadNoticeCount"] isEqual:@"0"]) {
            proclamationcell.proclamationTitleLabel.text = @"暂无公告";
            proclamationcell.taskAddImageView.hidden = NO;
            
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
        [self gainToNewNoticeDetail:[proclamationDic objectForKey:@"lastNoticeId"]];
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
