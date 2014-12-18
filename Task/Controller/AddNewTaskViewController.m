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
}

@end

@implementation AddNewTaskViewController
@synthesize taskTitleLabel;
@synthesize selectTaskEndTimeBtn;
@synthesize selectTaskLeaderBtn;
@synthesize saveWithContinueAddNewTaskBtn;
@synthesize saveWithPerfectTaskInfoBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    taskTitleLabel.delegate = self;
    
    rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewTaskInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectTaskLeader:(id)sender {
    [self hidenTaskTitleTextField];
}

- (IBAction)selectTaskEndTime:(id)sender {
    [self hidenTaskTitleTextField];
}

- (IBAction)saveWithContinueAddNewTask:(id)sender {
    [self hidenTaskTitleTextField];
    saveType = @"1";
}

- (IBAction)saveWithPerfectTaskInfo:(id)sender {
    [self hidenTaskTitleTextField];
    saveType = @"2";
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
    saveType = @"0";
    [self submitNewTaskInfo];
}

- (void)submitNewTaskInfo {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    //    [self createAsynchronousRequest:AttendanceMonthAction parmeters:parameters success:^(NSDictionary *dic){
    //        [self dealWithGainAttendanceInfoResult: dic];
    //    }];
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
                [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            }else if ([saveType isEqualToString:@"1"]) {
                // 新增
                self.taskTitleLabel.text = @"";
                [self btnIsForbid];
            }else if ([saveType isEqualToString:@"2"]) {
                // 跳转到完善信息页面
            }
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:true];
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

@end
