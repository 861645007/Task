//
//  LogInViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize personNameTextField;
@synthesize personPasswordTextField;
@synthesize loginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->keyboardSize.height = 216;
    self->textFieldArr = @[personNameTextField, personPasswordTextField];
    [self setCustomKeyboard:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logIn:(id)sender {
    if ([self TextFieldIsFull:self->textFieldArr]) {
        [self hidenKeyboardWithTextField];
        //进行网络操作
        [self logInWithNetService];
        [self.view.window showHUDWithText:@"正在登录..." Type:ShowLoading Enabled:true];
    }else {
        //提醒用户进行输入完整
        [self createSimpleAlertView:@"抱歉" msg:@"请输入完整信息"];
    }
}


- (void)logInWithNetService {
    //参数
    NSDictionary *parameters = @{@"username":personNameTextField.text, @"password": personPasswordTextField.text};
    
    [self createAsynchronousRequest:AttendanceMonthAction parmeters:parameters success:^(NSDictionary *dic){
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
            [self.view.window showHUDWithText:@"登录成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(savePersonInfo:) withObject:dic afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:msg];
    }
}

- (void)savePersonInfo:(NSDictionary *)dic {
    //设置用户登录标志
    [userInfo saveUserCookie];
    //保存用户信息
    [userInfo saveUserLogInName:personNameTextField.text];
    [userInfo saveUserLogInPwd:personPasswordTextField.text];
    [self gotoMainViewController];
}

//转到主界面
- (void)gotoMainViewController {
    //视图转换 至 rootViewController  （原理：直接将根视图转换----只能在主线程生调用）
    REFrostedViewController *frosted = [[REFrostedViewController alloc] initWithContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"] menuViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"]];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = frosted;
    
    
}

@end
