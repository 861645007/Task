//
//  ModifyTaskTitleViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/21.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ModifyTaskTitleViewController.h"

@interface ModifyTaskTitleViewController ()

@end

@implementation ModifyTaskTitleViewController
@synthesize title;
@synthesize taskContent;
@synthesize taskId;
@synthesize delegate;
@synthesize taskContentTextView;
@synthesize taskInstructionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"输入%@", title];
    self.taskInstructionLabel.text = [NSString stringWithFormat:@"请添加新的%@", title];
    self.taskContentTextView.text = taskContent;
    self.taskContentTextView.layer.borderWidth = 0.5;
    [self.taskContentTextView becomeFirstResponder];

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submitModifyTaskInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitModifyTaskInfo {
    [self hidenKeyBoard];
    if ([taskContentTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:[NSString stringWithFormat:@"请添加新的%@", title]];
        return ;
    }
    
    if ([delegate respondsToSelector:@selector(modifyTaskContextInfo:)]) {
        [self.delegate modifyTaskContextInfo:taskContentTextView.text];
    }
    
    [self comeBack];
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:true];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hiddenKeyboard:(id)sender {
    [self hidenKeyBoard];
}

- (void)hidenKeyBoard {
    [taskContentTextView resignFirstResponder];
}
@end
