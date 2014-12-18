//
//  TaskViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController (){
    NSArray *navArr;
    NSArray *sectionArr;
    NSMutableArray *isShow;
    NSMutableDictionary *tableVieDataDic;
}

@end

@implementation TaskViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏为可点击
    navArr = @[@"item1", @"选项2", @"选项3", @"我的任务"];
    CusNavigationTitleView *navView = [[CusNavigationTitleView alloc] initWithTitle:@"我的任务" titleStrArr:navArr imageName:@"Expansion"];
    __block CusNavigationTitleView *copyNavView = navView; // 防止陷入“retain cycle” -- “形成怪圈”的错误
    navView.selectRowAtIndex = ^(NSInteger index){
        copyNavView.titleString = navArr[(long)index];
    };
    self.navigationItem.titleView = navView;
    
    // 设置 tableView
    sectionArr = @[@"延期", @"今天", @"明天", @"即将", @"无日期"];
    isShow = [NSMutableArray array];
    for (int i = 0; i<[sectionArr count]; i++) {
        [isShow addObject:@"0"];
    }
    tableVieDataDic = [NSMutableDictionary dictionary];
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainAttendanceInfo];
    }];
    
    [self gainAttendanceInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
// 获取数据
- (void)gainAttendanceInfo {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:AttendanceMonthAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainAttendanceInfoResult: dic];
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
            [self.view.window showHUDWithText:@"获取考勤成功" Type:ShowPhotoYes Enabled:YES];

            // 事情做完了, 结束刷新动画~~~
            [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
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
        return [[tableVieDataDic objectForKey:keys] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15, 7, 30, 21)];
    numberLabel.tag = 200;
    numberLabel.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
    numberLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 9, 25, 25)];
    imageView.tag = 201;
    imageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewTask)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    if ([[tableVieDataDic objectForKey:key] count] != 0) {
        numberLabel.text = [NSString stringWithFormat:@"%d", [[tableVieDataDic objectForKey:key] count]];
        imageView.hidden = true;
    }else {
        imageView.image = [UIImage imageNamed:@"Task_Add"];
        numberLabel.text = [NSString stringWithFormat:@"%d", 0];
        numberLabel.hidden = true;
    }
    
    [sectionView addSubview:numberLabel];
    [sectionView addSubview:titleLabel];
    [sectionView addSubview:btn];
    [sectionView addSubview:imageView];
    return sectionView;
}

// 添加新的任务
- (void)addNewTask {
    AddNewTaskViewController *addNewTaskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTaskViewController"];
    [self.navigationController pushViewController:addNewTaskViewController animated:true];
}

// 点击 section 后的触发事件
- (void)btnClick:(UIButton *)btn
{
    UIView *headerView = [self.mainTableView headerViewForSection:btn.tag];
    UILabel *numberLabel = (UILabel *)[headerView viewWithTag:200];
    UIImageView *imageView = (UIImageView *)[headerView viewWithTag:201];
    
    if ([[isShow objectAtIndex:btn.tag] intValue]) {
        isShow[btn.tag] = @"0";
        if ([numberLabel.text isEqualToString:@"0"]) {
            imageView.hidden = false;
            numberLabel.hidden = true;
        }else {
            imageView.hidden = true;
            numberLabel.hidden = false;
        }
    }
    else {
        isShow[btn.tag] = @"1";
        imageView.hidden = false;
        numberLabel.hidden = true;
        
    }
    // 刷新点击的组标题，动画使用卡片
    [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag]
                 withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LeaveRecordInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    return cell;
}

// 截图时间
- (NSString *)setFirstTextTime:(NSString *)timeStr {
    NSArray *timeArr = [timeStr componentsSeparatedByString:@" "];
    return timeArr[0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}
@end
