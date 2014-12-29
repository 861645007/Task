//
//  AddNewProclamationViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AddNewProclamationViewController.h"

@interface AddNewProclamationViewController ()

@end

@implementation AddNewProclamationViewController
@synthesize proclamationTextView;
@synthesize noticeId;
@synthesize proclamationContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    proclamationTextView.layer.borderWidth = .5f;
    proclamationTextView.text = proclamationContext;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitProclamationInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 新增公告信息
- (void)submitProclamationInfo {
    if ([proclamationTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请输入公告内容"];
    }
    
    [self.proclamationTextView resignFirstResponder];
    [self.view.window showHUDWithText:@"正在提交" Type:ShowLoading Enabled:YES];
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    
    //参数
    NSDictionary *parameters;
    if ([[NSString stringWithFormat:@"%@",noticeId] isEqualToString:@""]) {
        parameters = @{@"employeeId": employeeId,
                       @"realName":realName,
                       @"enterpriseId": enterpriseId,
                       @"content": proclamationTextView.text};
    }else {
        parameters = @{@"employeeId": employeeId,
                       @"realName":realName,
                       @"enterpriseId": enterpriseId,
                       @"noticeId":noticeId,
                       @"content": proclamationTextView.text};
    }
    
    
    [self createAsynchronousRequest:PublishNoticeAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithUserBaseInfoResult: dic];
    } failure:^{}];
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
            [self.view.window showHUDWithText:@"编辑公告成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hiddenKeyboard:(id)sender {
    [proclamationTextView resignFirstResponder];
}
@end
