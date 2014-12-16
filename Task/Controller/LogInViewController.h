//
//  LogInViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface LogInViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *personNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *personPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)logIn:(id)sender;

@end

