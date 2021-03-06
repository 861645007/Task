//
//  PersonInfoViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/3.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonInfoTableViewCell.h"
#import "PlistOperation.h"
#import "ChangePwdViewController.h"
#import "AddNewTaskViewController.h"

@interface PersonInfoViewController () {
    NSDictionary *personInfoDic;
    NSMutableArray *personInfoArr;
    
    NSInteger selectIndex;
    NSString *headerNameListStr;
}

@end

@implementation PersonInfoViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectIndex = 0;
    headerNameListStr = @"";
    personInfoArr = [NSMutableArray arrayWithArray:@[@{@"部门:": @""}, @{@"角色:": @""}, @{@"电话:": @""}, @{@"Email:": @""}, @{@"上级:": @""}, @{@"下级:": @""}]];
    
    self.mainTableView.tableHeaderView = [self setMaiTableHeaderView];
    [self setTableFooterView:self.mainTableView];
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainPersonInfo];
    }];
    
    [self gainPersonInfo];
}

// TableView 的头文件
- (UIView *)setMaiTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, self.view.frame.size.width, 210)];
    
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -8, self.view.frame.size.width + 10, 180)];
    bgImageView.image = [UIImage imageNamed:@"card_bg"];
    [headerView addSubview:bgImageView];
    
    // 头像
    UIView *bgHeaderImageView = [[UIView alloc] initWithFrame:CGRectMake(15, 125, 90, 90)];
    [bgHeaderImageView setBackgroundColor:[UIColor whiteColor]];
    bgHeaderImageView.layer.masksToBounds = YES;
    bgHeaderImageView.layer.cornerRadius = 45;
    bgHeaderImageView.layer.borderWidth = 2;
    bgHeaderImageView.layer.borderColor = GrayColorForTitle.CGColor;
    [headerView addSubview:bgHeaderImageView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 130, 80, 80)];
    headerImageView.backgroundColor = [UIColor clearColor];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 40.0;
    [headerImageView setImage:[self gainHeaderImageImage]];
    [headerView addSubview:headerImageView];
    
    UILabel *personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 138, 100, 21)];
    personNameLabel.text = [userInfo gainUserName];
    personNameLabel.font = [UIFont systemFontOfSize:20];
    [personNameLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:personNameLabel];
    
    // 按钮
    UIButton *createTaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 180, 85, 30)];
    createTaskBtn.layer.cornerRadius = 5.0;
    createTaskBtn.layer.borderWidth = 1;
    createTaskBtn.layer.borderColor = [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0].CGColor;
    [createTaskBtn addTarget:self  action:@selector(createNewTask) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    [image1 setImage:[UIImage imageNamed:@"card_hairtask"]];
    [createTaskBtn addSubview:image1];
    UILabel *createTaskBtnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 5, 50, 20)];
    createTaskBtnNameLabel.font = [UIFont systemFontOfSize:15];
    createTaskBtnNameLabel.text = @"发任务";
    [createTaskBtnNameLabel setTextColor:[UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0]];
    [createTaskBtn addSubview:createTaskBtnNameLabel];
    [headerView addSubview:createTaskBtn];
    
    
    UIButton *changePwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(215, 180, 85, 30)];
    changePwdBtn.layer.cornerRadius = 5.0;
    changePwdBtn.layer.borderWidth = 1;
    changePwdBtn.layer.borderColor = [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0].CGColor;
    [changePwdBtn addTarget:self  action:@selector(changePwdBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    [image2 setImage:[UIImage imageNamed:@"ic_password"]];
    [changePwdBtn addSubview:image2];
    
    UILabel *changePwdBtnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 5, 50, 20)];
    changePwdBtnNameLabel.font = [UIFont systemFontOfSize:15];
    changePwdBtnNameLabel.text = @"改密码";
    [changePwdBtnNameLabel setTextColor:[UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0]];
    [changePwdBtn addSubview:changePwdBtnNameLabel];
    [headerView addSubview:changePwdBtn];
    
    return headerView;
}

- (UIImage *)gainHeaderImageImage {
    NSArray *array = [[PlistOperation shareInstance] gainAllPersonInfoWithFile];
    NSString *userId = [userInfo gainUserId];
    NSString *userImageName = @"";
    
    for (NSDictionary *dic in array) {
        NSString *employeeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"employeeId"]];
        if ([userId isEqual:employeeId]) {
            userImageName = [dic objectForKey:@"image"];
            break;
        }
    }
    
    UIImage *img = [[PlistOperation shareInstance] gainPersonImage:userImageName];
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)createNewTask {
    AddNewTaskViewController *addNewTaskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTaskViewController"];
    addNewTaskViewController.taskId = @"";
    addNewTaskViewController.taskEndTimeStr = @"";
    [self.navigationController pushViewController:addNewTaskViewController animated:true];
}

- (void)changePwdBtn {
    ChangePwdViewController *changePwdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwdViewController"];
    [self.navigationController pushViewController:changePwdViewController animated:YES];
}

#pragma mark - 获取数据
- (void)gainPersonInfo {
    [self.view.window showHUDWithText:@"加载数据..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:EmployeeInfoAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainPersonInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowPhotoNo Enabled:YES];
    }];

}

//处理网络操作结果
- (void)dealWithGainPersonInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取数据成功" Type:ShowPhotoYes Enabled:YES];
            
            personInfoDic = [NSDictionary dictionaryWithDictionary:dic];
            [self dealWithResult:dic];
            
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

- (void)dealWithResult:(NSDictionary *)dic {
    [personInfoArr replaceObjectAtIndex:0 withObject:[self setPersonBaseInfo:@"部门:" rowContext:[dic objectForKey:@"departmentName"]]];
    [personInfoArr replaceObjectAtIndex:1 withObject:[self setPersonBaseInfo:@"角色:" rowContext:[dic objectForKey:@"role"]]];
    [personInfoArr replaceObjectAtIndex:2 withObject:[self setPersonBaseInfo:@"电话:" rowContext:[dic objectForKey:@"phone"]]];
    [personInfoArr replaceObjectAtIndex:3 withObject:[self setPersonBaseInfo:@"Email:" rowContext:[dic objectForKey:@"email"]]];
    [personInfoArr replaceObjectAtIndex:4 withObject:[self setPersonEmployeeNames:@"上级:" employeeArr:[dic objectForKey:@"upEmployees"] employeeKey:@"upEmployeeName"]];
    [personInfoArr replaceObjectAtIndex:5 withObject:[self setPersonEmployeeNames:@"下级:" employeeArr:[dic objectForKey:@"downEmployees"] employeeKey:@"downEmployeeName"]];
    
    // 保存用户基本信息至本地
    [userInfo saveUserDepartment:[dic objectForKey:@"departmentName"]];
    [userInfo saveUserEmail:[dic objectForKey:@"email"]];
    [userInfo saveUserPhone:[dic objectForKey:@"phone"]];
    
}

// 设置用户的 部门，电话，Email
- (NSDictionary *)setPersonBaseInfo:(NSString *)rowTitle rowContext:(NSString *)rowContext {
    return  @{rowTitle: [self judgeTextIsNULL:rowContext]};
}

// 设置用户的 上下级
- (NSDictionary *)setPersonEmployeeNames:(NSString *)towTitle employeeArr:(NSArray *)employeeArr employeeKey:(NSString *)employeeKey {
    NSString *employeeStr = @"";
    
    if ([employeeArr count] != 0) {
        for (NSDictionary *dic in employeeArr) {
            if ([dic isEqualToDictionary:[employeeArr lastObject]]) {
                employeeStr = [employeeStr stringByAppendingFormat:@"%@", [dic objectForKey:employeeKey]];
            }else {
                employeeStr = [employeeStr stringByAppendingFormat:@"%@,", [dic objectForKey:employeeKey]];
            }
        }
    }
    
    return @{towTitle: employeeStr};
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [personInfoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PersonInfoCell";
    PersonInfoTableViewCell *cell = (PersonInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dic = [personInfoArr objectAtIndex:indexPath.row];
    NSString *key = [[dic allKeys] firstObject];
    
    cell.personTitleLabel.text = key;
    cell.personContextLabel.text = [dic objectForKey:key];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [personInfoArr objectAtIndex:indexPath.row];
    NSString *key = [[dic allKeys] firstObject];
    if ([key isEqualToString: @"上级:"] || [key isEqualToString:@"下级:"]) {
        selectIndex = indexPath.row;
        [self setUpOrDownEmployees];
    }
    
}


#pragma mark - 设置上下级
- (void)setUpOrDownEmployees {
    SelectHeaderViewController *selectHeaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectHeaderViewController"];
    selectHeaderViewController.delegate = self;
    selectHeaderViewController.isRadio = 1;
    if (selectIndex == 4) {
        selectHeaderViewController.viewTitle = @"选择上级";
    }else {
        selectHeaderViewController.viewTitle = @"选择下级";
    }
    [self.navigationController pushViewController:selectHeaderViewController animated:YES];
}

// 返回联系人
- (void)selectedHeader:(NSArray *)headerList {
    NSString *headerIdList = @"";
    headerNameListStr = @"";
    for (NSDictionary *dic in headerList) {
        if ([dic isEqual:[headerList lastObject]]) {
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"realName"]];
            headerIdList = [headerIdList stringByAppendingFormat:@"%@",[dic objectForKey:@"employeeId"]];
            
        }else {
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"realName"]];
            headerIdList = [headerIdList stringByAppendingFormat:@"%@,",[dic objectForKey:@"employeeId"]];
        }
    }
    
    if ([headerList isEqualToArray:@[]]) {
        if (selectIndex == 4) {
            [personInfoArr replaceObjectAtIndex:4 withObject:[self setPersonEmployeeNames:@"上级:" employeeArr:@[@{@"upEmployeeName": @"请选择负责人"}]  employeeKey:@"upEmployeeName"]];
        }else {
            [personInfoArr replaceObjectAtIndex:5 withObject:[self setPersonEmployeeNames:@"下级:" employeeArr:@[@{@"downEmployeeName": @"请选择负责人"}] employeeKey:@"downEmployeeName"]];
        }
        [mainTableView reloadData];
    }else {
        [self submitEmployees:headerIdList];
    }
}

- (void)submitEmployees:(NSString *)employeeIds {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId}];
    
    NSString *action = @"";
    if (selectIndex == 4) {
        action = SetUpEmployeesAction;
        [parameters setValue:employeeIds forKey:@"upEmployeeIds"];
    }else {
        action = SetDownEmployeesAction;
        [parameters setValue:employeeIds forKey:@"downEmployeeIds"];
    }
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainProclamationInfoResult: dic];
    } failure:^{}];
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
            [self.view.window showHUDWithText:@"修改信息成功" Type:ShowPhotoYes Enabled:YES];
            
            if (selectIndex == 4) {
                [personInfoArr replaceObjectAtIndex:4 withObject:[self setPersonEmployeeNames:@"上级:" employeeArr:@[@{@"upEmployeeName": headerNameListStr}] employeeKey:@"upEmployeeName"]];
            }else {
                [personInfoArr replaceObjectAtIndex:5 withObject:[self setPersonEmployeeNames:@"下级:" employeeArr:@[@{@"downEmployeeName": headerNameListStr}] employeeKey:@"downEmployeeName"]];
            }
            
            [mainTableView reloadData];
            break;
        }
    }

    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }

}

@end
