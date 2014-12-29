//
//  BaseViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userInfo = [UserInfo shareInstance];
    
    //设置NavigationBar背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置圆角
- (void)setBtnCircleBead:(UIButton *)senderBtn {
    senderBtn.layer.masksToBounds = YES;
    senderBtn.layer.cornerRadius = 5.0;
}

- (void)setViewCircleBead:(UIView *)senderView {
    senderView.layer.masksToBounds = YES;
    senderView.layer.cornerRadius = 5.0;
}

- (void)createSimpleAlertView:(NSString *)title msg:(NSString *)msg {
    //提醒用户进行输入完整
    BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:title message:msg subView:nil viewController:self];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        NSLog(@"1");
    }];
    [alertView addButton:cancelItem type:RIButtonItemType_Cancel];
    [alertView show];
}

#pragma mark - 网络操作
- (void)createAsynchronousRequest:(NSString *)action parmeters:(NSDictionary *)parmeters success:(void(^)(NSDictionary *dic))success failure:(Failure)failure {
    
    NSURL *url = [NSURL URLWithString:HttpURL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:action parameters:parmeters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();       
        NSLog(@"error: %@, \n error.localizedDescription: %@", error, [error localizedDescription]);
        [self.view.window showHUDWithText:@"网络错误..." Type:ShowPhotoNo Enabled:YES];
    }];
}

#pragma mark 去除 tableView 多余的横线
- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}


#pragma mark - 键盘操作
- (void)setCustomKeyboard:(id)delegate {
    //键盘操作
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    for (UITextField *textField in textFieldArr) {
        //指定本身为代理
        textField.delegate = delegate;
        
        //指定编辑时键盘的return键类型
        if ([textField isEqual:[textFieldArr lastObject]]) {
            textField.returnKeyType = UIReturnKeyDefault;
        }else {
            textField.returnKeyType = UIReturnKeyNext;
        }
        //注册键盘响应事件方法
        [textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboardWithTextField)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    CGRect frame = textField.frame;
    CGRect frame = textField.superview.frame;
    //获取键盘大小
    int offset = frame.origin.y + 260 + 60 - (self.view.frame.size.height - keyboardSize.height);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//隐藏键盘的方法
-(void)hidenKeyboardWithTextField
{
    for (UITextField *textField in textFieldArr) {
        //指定本身为代理
        [textField resignFirstResponder];
    }
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if ([sender isEqual: [textFieldArr lastObject]]) {
        [self hidenKeyboardWithTextField];
        return;
    }else {
        for (int i = 0; i < [textFieldArr count]; i++) {
            if ([sender isEqual:[textFieldArr objectAtIndex:i]]) {
                [[textFieldArr objectAtIndex:i + 1] becomeFirstResponder];
            }
        }
        return;
    }
}

#pragma mark - 判断输入框是否有输入
- (BOOL)TextFieldIsFull:(NSArray *)textFieldArr1 {
    for (UITextField *textField in textFieldArr1) {
        if ([textField.text isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 判断一个数据是不是 NSNull 类型
- (NSString *)judgeTextIsNULL:(id)text {
    if (text == [NSNull null]) {
        return @"";
    }
    return text;
}

@end
