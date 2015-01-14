//
//  AddNewTaskViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AddNewTaskViewController.h"

@interface AddNewTaskViewController () {
    UIBarButtonItem *rightBar;
    NSString *saveType;        // 0：直接保存   1：保存并继续添加   2：保存并完善信息
    NSString *headerIdStrList;
}

@end

@implementation AddNewTaskViewController
@synthesize taskTitleLabel;
@synthesize selectTaskEndTimeBtn;
@synthesize selectTaskLeaderBtn;
@synthesize saveWithContinueAddNewTaskBtn;
@synthesize saveWithPerfectTaskInfoBtn;
@synthesize taskId;
@synthesize taskEndTimeStr;
@synthesize superTaskId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    taskTitleLabel.delegate = self;
    headerIdStrList = [NSString string];
    
    if ([taskEndTimeStr isEqualToString:@""] || taskEndTimeStr == nil) {
        [selectTaskEndTimeBtn setTitle:@"选择到期日" forState:UIControlStateNormal];
        [selectTaskEndTimeBtn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else {
       [selectTaskEndTimeBtn setTitle:taskEndTimeStr forState:UIControlStateNormal];
        [selectTaskEndTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewTaskInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"GoToSelectedHeaderView"]) {
        SelectHeaderViewController *selected = [segue destinationViewController];
        selected.delegate = self;
        selected.isRadio = 0;
    }
}

#define mark - 选择功能
- (IBAction)selectTaskLeader:(id)sender {
    [self hidenTaskTitleTextField];
}

- (IBAction)selectTaskEndTime:(id)sender {
    [self hidenTaskTitleTextField];
    CalendarHomeViewController *chvc;
    chvc = [[CalendarHomeViewController alloc]init];
    chvc.calendartitle = @"选择到期日";
    [chvc setAirPlaneToDay:365 * 2 ToDateforString:nil];//选择日期初始化方法
    
    chvc.calendarblock = ^(CalendarDayModel *model){
        [sender setTitle:[NSString stringWithFormat:@"%@",[model toString]] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:chvc animated:YES];
    
}

- (IBAction)saveWithContinueAddNewTask:(id)sender {
    [self hidenTaskTitleTextField];
    saveType = @"1";
    [self submitNewTaskInfo];
}

- (IBAction)saveWithPerfectTaskInfo:(id)sender {
    [self hidenTaskTitleTextField];
    saveType = @"2";
    [self submitNewTaskInfo];
}

#pragma mark - 隐藏键盘
- (IBAction)hiddenKeyBoard:(id)sender {
    [self hidenTaskTitleTextField];
}

- (void)hidenTaskTitleTextField {
    [self.taskTitleLabel resignFirstResponder];
}

#pragma mark - 保存信息
- (void)saveNewTaskInfo {
    [self hidenTaskTitleTextField];
    saveType = @"0";
    [self submitNewTaskInfo];
}

- (void)submitNewTaskInfo {
    if ([selectTaskLeaderBtn.titleLabel.text isEqualToString:@"选择负责人"]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请选择负责人"];
        return ;
    }
    
    
    [self.view.window showHUDWithText:@"正在提交" Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];

    
    //参数
    NSDictionary *parameters;
    if (superTaskId != nil) {
        parameters = @{@"employeeId": employeeId,
                       @"realName":realName,
                       @"enterpriseId": enterpriseId,
                       @"title":taskTitleLabel.text,
                       @"principalId": headerIdStrList,
                       @"principalName": selectTaskLeaderBtn.titleLabel.text,
                       @"deadline": selectTaskEndTimeBtn.titleLabel.text,
                       @"parentId": superTaskId};
    }else {
        if ([taskId isEqual:@""]) {
            parameters = @{@"employeeId": employeeId,
                           @"realName":realName,
                           @"enterpriseId": enterpriseId,
                           @"title":taskTitleLabel.text,
                           @"principalId": headerIdStrList,
                           @"principalName": selectTaskLeaderBtn.titleLabel.text,
                           @"deadline": selectTaskEndTimeBtn.titleLabel.text};
            
        }else {
            parameters = @{@"employeeId": employeeId,
                           @"realName":realName,
                           @"enterpriseId": enterpriseId,
                           @"taskId": employeeId,
                           @"title":taskTitleLabel.text,
                           @"principalId": headerIdStrList,
                           @"principalName": selectTaskLeaderBtn.titleLabel.text,
                           @"deadline": selectTaskEndTimeBtn.titleLabel.text};
        }
    }

    [self createAsynchronousRequest:AddTaskAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainAttendanceInfoResult: dic];
    } failure:^{}];
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
            [self.view.window showHUDWithText:@"新建任务成功" Type:ShowPhotoYes Enabled:YES];
            if ([saveType isEqualToString:@"0"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTaskMainView" object:@"1"];
                [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            }else if ([saveType isEqualToString:@"1"]) {
                // 新增
                self.taskTitleLabel.text = @"";
                [self btnIsForbid];
            }else if ([saveType isEqualToString:@"2"]) {
                // 跳转到完善信息页面
                [self performSelector:@selector(gainToDetailInfoView:) withObject:[dic objectForKey:@"taskId"] afterDelay:0.9];
            }
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeBack {
    if (superTaskId != nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

- (void)gainToDetailInfoView:(NSString *)newTaskId {
    TaskDetailInfoTableViewController *taskDetailInfoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailInfoTableViewController"];
    taskDetailInfoTableViewController.taskId = newTaskId;
    [self.navigationController pushViewController:taskDetailInfoTableViewController animated:YES];
}

#pragma mark - TextView 判断保存按钮是否可以被点击
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {//检测到“完成”
        [taskTitleLabel resignFirstResponder];//释放键盘
        return NO;
    }
    
    if (taskTitleLabel.text.length==0){//textview长度为0
        [self btnIsForbid];
    }else{//textview长度不为0
        if (taskTitleLabel.text.length==1){//textview长度为1时候
            if ([string isEqualToString:@""]) {//判断是否为删除键
                [self btnIsForbid];
            }else{//不是删除
                [self btnIsAllow];
            }
        }else{//长度不为1时候
            [self btnIsAllow];
        }
    }
    return YES;
}

- (void)btnIsForbid {
    saveWithPerfectTaskInfoBtn.userInteractionEnabled = NO;
    saveWithContinueAddNewTaskBtn.userInteractionEnabled = NO;
    [saveWithPerfectTaskInfoBtn setBackgroundColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]];
    [saveWithContinueAddNewTaskBtn setBackgroundColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]];
}

- (void)btnIsAllow {
    saveWithPerfectTaskInfoBtn.userInteractionEnabled = YES;
    saveWithContinueAddNewTaskBtn.userInteractionEnabled = YES;
    saveWithContinueAddNewTaskBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    saveWithPerfectTaskInfoBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    
}

#pragma mark - 返回负责人 
- (void)selectedHeader:(NSArray *)headerList {
    NSString *headerListStr = @"";
    for (NSDictionary *dic in headerList) {
        if ([dic isEqual:[headerList lastObject]]) {
            headerListStr = [headerListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"realName"]];
            headerIdStrList = [headerIdStrList stringByAppendingFormat:@"%@",[dic objectForKey:@"employeeId"]];

        }else {
            headerListStr = [headerListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"realName"]];
            headerIdStrList = [headerIdStrList stringByAppendingFormat:@"%@,",[dic objectForKey:@"employeeId"]];
        }
    }
    
    if ([headerList isEqualToArray:@[]]) {
        [selectTaskLeaderBtn setTitle:@"请选择负责人" forState:UIControlStateNormal];
        [selectTaskLeaderBtn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else {
        [selectTaskLeaderBtn setTitle:headerListStr forState:UIControlStateNormal];
        [selectTaskLeaderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}



@end
