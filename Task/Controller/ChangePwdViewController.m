//
//  ChangePwdViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/4.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *personOldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *personNewPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *perosnSurePwdTextField;

@end

@implementation ChangePwdViewController
@synthesize perosnSurePwdTextField;
@synthesize personNewPwdTextField;
@synthesize personOldPwdTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(submitNewPwd)];
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

#pragma mark - submitNewPwd
- (void)submitNewPwd {
    
    if ([personOldPwdTextField.text isEqualToString:@""] || [personNewPwdTextField.text isEqualToString:@""] || [perosnSurePwdTextField.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请填写完整信息"];
        return ;
    }

    [self.view.window showHUDWithText:@"正在修改..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName": realName,
                                 @"enterpriseId": enterpriseId,
                                 @"oldPwd": personOldPwdTextField.text,
                                 @"newPwd": personNewPwdTextField.text,
                                 @"confirmPwd": perosnSurePwdTextField.text};
    
    [self createAsynchronousRequest:ChangePwdAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainPersonInfoResult: dic];
    } failure:^{
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowLoading Enabled:YES];
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
            [self.view.window showHUDWithText:@"修改成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:self afterDelay:0.9];
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

@end
