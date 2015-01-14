//
//  AutoUpdateVersion.m
//  Task
//
//  Created by wanghuanqiang on 15/1/14.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "AutoUpdateVersion.h"
#import "BaseViewController.h"

@implementation AutoUpdateVersion

//  isAutoSelected: 1表示自动； 0表示手动
- (void)checkNewVersion:(UIViewController *)baseViewController isAutoSelected:(int)isAutoSelected {
    if (!isAutoSelected) {
        [baseViewController.view.window showHUDWithText:@"正在查询..." Type:ShowLoading Enabled:YES];
    }
    
    NSString *employeeId = [[UserInfo shareInstance] gainUserId];
    NSString *realName = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName": realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:AutoUpdateIOSAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainPersonInfoResult: dic baseViewController:baseViewController isAutoSelected:isAutoSelected];
    } failure:^{
        if (!isAutoSelected) {
            [baseViewController.view.window showHUDWithText:@"网络错误..." Type:ShowLoading Enabled:YES];
        }
    } baseViewController:baseViewController];
}


//处理网络操作结果
- (void)dealWithGainPersonInfoResult:(NSDictionary *)dic baseViewController:(UIViewController *)baseViewController isAutoSelected:(int)isAutoSelected {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            float versionCode = [[dic objectForKey:@"versionCode"] floatValue];
            if (versionCode > [self gainAPPVersion]) {
                BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@\n您的当前版本为:%@", [dic objectForKey:@"description"], [dic objectForKey:@"versionName"]] subView:nil viewController:baseViewController];
                
                RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^{}];
                [alertView addButton:cancelItem type:RIButtonItemType_Other];
                
                RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"升级" action:^{
                    [[dic objectForKey:@"urlAddress"] openWebURL];
                }];
                [alertView addButton:okItem type:RIButtonItemType_Other];
                
                [alertView show];
            }else {
                if (!isAutoSelected) {
                    BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:@"温馨提示"  message:[NSString stringWithFormat:@"%@\n您的当前版本为:%@",[dic objectForKey:@"description"], [dic objectForKey:@"versionName"]] subView:nil viewController:baseViewController];
                    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"确定" action:^{
                        NSLog(@"1");
                    }];
                    [alertView addButton:cancelItem type:RIButtonItemType_Cancel];
                    [alertView show];
                }
            }
            
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        if (!isAutoSelected) {
            [baseViewController.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
        }
    }
}

- (float)gainAPPVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [appVersion floatValue];
}

// 网络请求
- (void)createAsynchronousRequest:(NSString *)action parmeters:(NSDictionary *)parmeters success:(void(^)(NSDictionary *dic))success failure:(Failure)failure baseViewController:(UIViewController *)baseViewController {
    
    NSURL *url = [NSURL URLWithString:HttpURL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:action parameters:parmeters success:^(NSURLSessionDataTask *task, id responseObject) {
        [baseViewController.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
        NSLog(@"error: %@, \n error.localizedDescription: %@", error, [error localizedDescription]);
    }];
}

@end
