//
//  ApprovesLeaveViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ApprovesLeaveViewController.h"

@interface ApprovesLeaveViewController () {
    NSString *deliverIdsStr;
    NSString *deliverNamesStr;
}

@end

@implementation ApprovesLeaveViewController
@synthesize agreeLeaveBtn;
@synthesize disagreeLeaveBtn;
@synthesize approvesDescTextView;
@synthesize selectedDeliverPersonBtn;
@synthesize leaveId;
@synthesize leaveApproveId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    deliverIdsStr = @"";
    deliverNamesStr = @"";
    approvesDescTextView.layer.borderWidth = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择是否同意请假
- (IBAction)disagreeLeave:(id)sender {
    if (disagreeLeaveBtn.tag == 0) {
        disagreeLeaveBtn.tag = 1;
        agreeLeaveBtn.tag = 0;
        [self setBtnImage];
    }
}

- (IBAction)agreeLeave:(id)sender {
    if (agreeLeaveBtn.tag == 0) {
        agreeLeaveBtn.tag = 1;
        disagreeLeaveBtn.tag = 0;
        [self setBtnImage];
    }
}

// 重新设置三个按钮的图片
- (void)setBtnImage {
    [self hiddenKeyboard];
    [self setSelectImageView:agreeLeaveBtn];
    [self setSelectImageView:disagreeLeaveBtn];
}

// 设置按钮的图片
- (void)setSelectImageView:(UIButton *)btn {
    if (btn.tag == 0) {
        [btn setImage:[UIImage imageNamed:@"select_item_unchecked"] forState:UIControlStateNormal];
    } else if (btn.tag == 1) {
        [btn setImage:[UIImage imageNamed:@"select_item_checked"] forState:UIControlStateNormal];
    }
}

#pragma mark - 选择移交人
- (IBAction)selectedDeliverPerson:(id)sender {
    SelectHeaderViewController *selected = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectHeaderViewController"];
    selected.viewTitle = @"移交人";
    selected.delegate  = self;
    selected.isRadio   = 0;
    [self.navigationController pushViewController:selected animated:YES];
}

#pragma mark - SelectedHeaderProtocol
- (void)selectedHeader:(NSArray *)headerList {
    NSString *headerIdListStr = @"";
    NSString *headerNameListStr = @"";
    for (NSDictionary *dic in headerList) {
        if ([dic isEqual:[headerList lastObject]]) {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"employeeId"]];
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"realName"]];
        }else {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"employeeId"]];
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"realName"]];
        }
    }
    
    [self.selectedDeliverPersonBtn setTitle:headerNameListStr forState:UIControlStateNormal];
    deliverIdsStr = headerIdListStr;
    deliverNamesStr = headerNameListStr;
    selectedDeliverPersonBtn.tag = 1;
}

#pragma mark - 选择提交
- (IBAction)approveLeave:(id)sender {
    // 判断是否选择了请假类型
    if (agreeLeaveBtn.tag == 0 && disagreeLeaveBtn.tag == 0) {
        [self createSimpleAlertView:@"抱歉" msg:@"请选择审核结果"];
        return ;
    }
    
    // 判断是否填写了请假原因
    if ([approvesDescTextView.text isEqual: @""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请填写审核描述"];
        return ;
    }
    
    [self submitApprovesLeaveInfo];
}

// 获取数据
- (void)submitApprovesLeaveInfo {
    [self.view.window showHUDWithText:@"提交审核..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    // 判断请假类型
    NSString *approveResult;
    if (agreeLeaveBtn.tag == 1) {
        approveResult = @"1";
    } else if (disagreeLeaveBtn.tag == 1) {
        approveResult = @"2";
    }
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"leaveId": leaveId, @"leaveApproveId":leaveApproveId, @"approveResult": approveResult, @"description": approvesDescTextView.text}];
    
    if (![deliverIdsStr isEqualToString:@""]) {
        [parameters setObject:deliverIdsStr forKey:@"deliverId"];
        [parameters setObject:deliverNamesStr forKey:@"deliverName"];
    }
    
    [self createAsynchronousRequest:ApproveLeaveAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithSubmitLeaveInfoResult: dic];
    } failure:^{}];
}

//处理网络操作结果
- (void)dealWithSubmitLeaveInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"审核成功" Type:ShowPhotoYes Enabled:YES];
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


#pragma mark - 隐藏键盘
- (IBAction)hidenKeyboard:(id)sender {
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard {
    [approvesDescTextView resignFirstResponder];
}
@end
