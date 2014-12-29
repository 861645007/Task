//
//  ProclamationCommentsViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationCommentsViewController.h"

@interface ProclamationCommentsViewController ()

@end

@implementation ProclamationCommentsViewController
@synthesize commentTextView;
@synthesize noticeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.commentTextView.layer.borderWidth = 0.5;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitProclamationCommentsInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitProclamationCommentsInfo {
    if ([commentTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请输入公告内容"];
    }
    [self.commentTextView resignFirstResponder];
    
    [self.view.window showHUDWithText:@"正在提交" Type:ShowLoading Enabled:YES];
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"noticeId":noticeId,
                                 @"content": commentTextView.text};;
    
    [self createAsynchronousRequest:NoticeAddCommentAction parmeters:parameters success:^(NSDictionary *dic){
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
            [self.view.window showHUDWithText:@"添加评论成功" Type:ShowPhotoYes Enabled:YES];
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

- (IBAction)hiddenKeboard:(id)sender {
    [commentTextView resignFirstResponder];
}
@end
