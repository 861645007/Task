//
//  LocationAttendanceViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/17.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LocationAttendanceViewController.h"

@interface LocationAttendanceViewController ()

@end

@implementation LocationAttendanceViewController
@synthesize attendancePatten;
@synthesize coordinate;
@synthesize commentTextView;
@synthesize attendanceType;
@synthesize address;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    commentTextView.layer.borderWidth = 0.5;
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

- (IBAction)sureAttendance:(id)sender {
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请输入考勤信息"];
    }
    
    [self signInAttendance];
}

- (IBAction)hiddenKeyboard:(id)sender {
    [self.commentTextView resignFirstResponder];
}

// 考勤
- (void)signInAttendance{
    [self.view.window showHUDWithText:@"正在考勤" Type:ShowLoading Enabled:true];
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"type": attendanceType, @"pattern":attendancePatten, @"longitude": [NSString stringWithFormat:@"%f", coordinate.longitude], @"latitude": [NSString stringWithFormat:@"%f", coordinate.latitude], @"address":address, @"phoneImei": @"123", @"description": commentTextView.text};
    
    [self createAsynchronousRequest:AttendanceAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithNetManageResult: dic];
    } failure:^{}];
}

//处理网络操作结果
- (void)dealWithNetManageResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"考勤成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
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

@end
