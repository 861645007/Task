//
//  ProclamationListViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationListViewController.h"

@interface ProclamationListViewController () {
    NSMutableArray *proclamationList;
}

@end

@implementation ProclamationListViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    proclamationList = [NSMutableArray array];
    
    // 历史界面按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProclamation)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainProclamationInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gainProclamationInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 新增公告 proclamation
- (void)addNewProclamation {
    AddNewProclamationViewController *addNewProclamationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewProclamationViewController"];
    addNewProclamationViewController.proclamationContext = @"";
    addNewProclamationViewController.noticeId = @"";
    [self.navigationController pushViewController:addNewProclamationViewController animated:YES];
}

#pragma mark - 获取公告信息
- (void)gainProclamationInfo {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:NoticeMonthListAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainProclamationInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowPhotoNo Enabled:YES];
    }];
}

//处理网络操作结果
- (void)dealWithGainProclamationInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取信息成功" Type:ShowPhotoYes Enabled:YES];
            if (![[dic objectForKey:@"noticeList"] isEqualToArray:@[]]) {
                [self setProclamationInfo:[dic objectForKey:@"noticeList"]];
                [mainTableView reloadData];
            }
            break;
        }
    }
    
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)setProclamationInfo:(NSArray *)arr {
    [proclamationList removeAllObjects];
    proclamationList = [NSMutableArray arrayWithArray:arr];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
    NSDictionary *dic = [proclamationList objectAtIndex:indexPath.row];
    
    ProclamationDetailInfoViewController *proclamationDetailInfoViewController = [segue destinationViewController];
    proclamationDetailInfoViewController.noticeId = [dic objectForKey:@"noticeId"];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [proclamationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdertifier = @"ProclamationListCell";
    ProclamationListCell *cell = (ProclamationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdertifier];
    
    NSDictionary *dic = [proclamationList objectAtIndex:indexPath.row];
    
    cell.proclamationContentLabel.text = [dic objectForKey:@"content"];
    cell.proclamationCreaterNameLabel.text = [dic objectForKey:@"realName"];
    cell.proclamationCreaterTimeLabel.text = [dic objectForKey:@"createTime"];
    
    return cell;
}

@end
