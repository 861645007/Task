//
//  RelateTaskListViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "RelateTaskListViewController.h"

@interface RelateTaskListViewController () {
    NSMutableArray *relateTaskList;
    NSMutableArray *isShow;             // 1已选中，0未选中
}

@end

@implementation RelateTaskListViewController
@synthesize mainTableView;
@synthesize taskId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    relateTaskList = [NSMutableArray array];
    isShow = [NSMutableArray array];
    
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submitRelateTaskList)];
    self.navigationItem.rightBarButtonItem = saveBar;
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainRelateTaskInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gainRelateTaskInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gainRelateTaskInfo {
    [self.view.window showHUDWithText:@"正在获取" Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId": taskId};
    
    [self createAsynchronousRequest:RelateTaskListAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainnRelateTaskInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }];
}

//处理网络操作结果
- (void)dealWithGainnRelateTaskInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取信息成功" Type:ShowPhotoYes Enabled:YES];
            
            if ([[dic objectForKey:@"relateList"] isEqualToArray:@[]]) {
                [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            }else {
                relateTaskList = [NSMutableArray arrayWithArray:[dic objectForKey:@"relateList"]];
                [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                
                for (NSDictionary *dic in relateTaskList) {
                    if ([[dic objectForKey:@"isRelate"] intValue] == 1) {
                        [isShow addObject:@"1"];
                    }else {
                        [isShow addObject:@"0"];
                    }
                }
            }
            
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


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([relateTaskList count] == 0) {
        return 0;
    }
    return  [relateTaskList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RelateTaskCell";
    RelateTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSDictionary *dic = [relateTaskList objectAtIndex:indexPath.row];
    
    cell.relateTaskTitleLabel.text = [dic objectForKey:@"title"];

    // 判断是否被选中
    if ([[isShow objectAtIndex:indexPath.row] intValue]) {
        cell.relateTaskStateImageView.image = [UIImage imageNamed:@"choose"];
    }else {
        cell.relateTaskStateImageView.image = [UIImage imageNamed:@"Addchoice"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[isShow objectAtIndex:indexPath.row] intValue]) {
        isShow[indexPath.row] = @"0";
    }else {
        isShow[indexPath.row] = @"1";
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 保存
- (void)submitRelateTaskList {
    
    NSString *relateTaskIds = @"";
    NSMutableArray *seletedTask = [NSMutableArray array];
    for (int i = 0; i < [isShow count]; i++) {
        if ([isShow[i] intValue]) {
            [seletedTask addObject:[[relateTaskList objectAtIndex:i] objectForKey:@"taskId"]];
        }
    }
    
    for (NSString *selectedTaskId in seletedTask) {
        if ([selectedTaskId isEqual:[seletedTask lastObject]]) {
            relateTaskIds = [relateTaskIds stringByAppendingFormat:@"%@", selectedTaskId];
        }else {
            relateTaskIds = [relateTaskIds stringByAppendingFormat:@"%@,", selectedTaskId];
        }
    }
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId": taskId,
                                 @"relateTaskIds": relateTaskIds};
    
    [self createAsynchronousRequest:AddRelateTaskAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithSubmitRelateTaskListResult: dic];
    } failure:^{ }];

}

- (void)dealWithSubmitRelateTaskListResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"提交成功" Type:ShowPhotoYes Enabled:YES];
            
            [self performSelector:@selector(comeback) withObject:nil afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeback {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
