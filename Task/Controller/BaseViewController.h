//
//  BaseViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKit+CustomExtension.h"
#import "LogInToolClass.h"
#import "UIWindow+YzdHUD.h"
#import "BOAlertController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "CLLocation+YCLocation.h"
#import "UserInfo.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "JHRefresh.h"
#import "CusNavigationTitleView.h"
#import "PopoverView.h"

#define HttpURL @"http://vmr82ksj.zhy35065.zhihui.chinaccnet.cn/staff.action"
#define LogInAction @"app_login.action"

@interface BaseViewController : UIViewController{
    CGSize keyboardSize;
    NSArray *textFieldArr;
    UserInfo *userInfo;
}

#pragma mark - 设置圆角
- (void)setViewCircleBead:(UIView *)senderView;
- (void)setBtnCircleBead:(UIButton *)senderBtn;

#pragma mark - 网络操作
- (void)createAsynchronousRequest:(NSString *)action parmeters:(NSDictionary *)parmeters success:(void(^)(NSDictionary *dic))success;

#pragma mark - 创建简单的警告框
- (void)createSimpleAlertView:(NSString *)title msg:(NSString *)msg;

#pragma mark - 键盘操作
- (void)setCustomKeyboard:(id)delegate;
-(void)hidenKeyboard;

/**
 *  判断输入框是否全部有输入
 *
 *  @param textFieldArr 输入框的集合
 *
 *  @return 全部有输入： 返回 yes;  有一个没有输入：返回 NO;
 */
- (BOOL)TextFieldIsFull:(NSArray *)textFieldArr;




@end
