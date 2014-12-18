//
//  WorkHomeViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "WorkHomeViewController.h"

@interface WorkHomeViewController () 
@end

@implementation WorkHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self detectionNetworkStatus]) {
        // 获取信息操作
        [self updateUserBaseInfo];
    }else {
        [self createSimpleAlertView:@"暂无网络" msg:@"请您打开手机流量"];
    }
}

- (BOOL)detectionNetworkStatus {
    if ([[DetectionNetworkStatus checkUpNetworkStatus] isEqualToString:@"0"]) {
        return false;
    }
    return true;
}

- (void)updateUserBaseInfo {
    NSString *userLogInName = [userInfo gainUserLogInName];
    NSString *userLogInPwd = [userInfo gainUserLogInPwd];
    
    //参数
    NSDictionary *parameters = @{@"type": @"IOS", @"username":userLogInName, @"password": userLogInPwd};
    
    [self createAsynchronousRequest:HomeAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithNetManageResult: dic];
    }];
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
            [self.view.window showHUDWithText:@"获取信息成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(savePersonInfo:) withObject:[dic objectForKey:@"userInfo"] afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)savePersonInfo:(NSDictionary *)dic {
    //保存用户信息
    [userInfo saveUserName:[dic objectForKey:@"realName"]];
    [userInfo saveUserPinyinName:[dic objectForKey:@"pinyinName"]];
    [userInfo saveUserId:[dic objectForKey:@"employeeId"]];
    [userInfo saveUserEnterpriseId:[dic objectForKey:@"enterpriseId"]];
    [userInfo saveUserIconPath:[dic objectForKey:@"image"]];
    [userInfo saveUserAttendace:[dic objectForKey:@"isAttendance"]];
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

#pragma mark - 菜单操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}
@end
