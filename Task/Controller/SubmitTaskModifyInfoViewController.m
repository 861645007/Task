//
//  SubmitTaskModifyInfoViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "SubmitTaskModifyInfoViewController.h"

@interface SubmitTaskModifyInfoViewController ()

@end

@implementation SubmitTaskModifyInfoViewController
@synthesize delegate;
@synthesize taskId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 提交修改任务
- (void)submitModifyTask:(NSString *)modifyStr cellTag:(int)clickCellTag {
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSString *action = @"";
    NSString *modifyKey = @"";
    
    int section = clickCellTag / 10;
    int row = clickCellTag % 10;
    
    if (section == 1) {
        switch (row) {
            case 0: {
                action = ChangeTaskTypeAction;
                modifyKey = @"type";
            }
                break;
            case 1: {
                action = ChangeTaskJoinUserAction;
                modifyKey = @"joinEmployeeIds";
            }
                break;
            case 2: {
                action = AddTaskSharedUserAction;
                modifyKey = @"sharedEmployees";
            }
                break;
            default:
                break;
        }
    }
    
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId": taskId,
                                 modifyKey: modifyStr};
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        if ([delegate respondsToSelector:@selector(comebackNetValue:)]) {
            [delegate comebackNetValue:dic];
        }

    } failure:^{}];
    
}


#pragma mark - 提交图片
- (void)submitModifyImage:(UIImage *)sImage {
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSData *imageData = UIImageJPEGRepresentation(sImage, 0.50);
    
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId":taskId};

    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",HttpURL, AddTaskAccessoryAction] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [[NSDate date] dateToStringWithDateFormat:@"hh-mm-ss"]];
        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([delegate respondsToSelector:@selector(comebackNetValue:)]) {
            [delegate comebackNetValue:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取服务器响应出错");
    }];
}


#pragma mark - 关注 等 ToolView 操作  还有 修改 content 操作
- (void)modifyTaskState:(NSString *)modifyStr atIndex:(int)index {
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSString *action = @"";
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"taskId": taskId}];
    

    switch (index) {
        case 0: {
            action = ChangeTaskAttendionUserAction;
            [parameters setValue:modifyStr forKey:@"type"];
        }
            break;
        case 1: {
            action = AddTaskReportAction;
            [parameters setValue:modifyStr forKey:@"description"];
        }
            break;
        case 2: {
            action = ChangeTaskStateAction;
            [parameters setValue:modifyStr forKey:@"state"];
        }
            break;
        case 4: {
            action = DeleteTaskAction;
        }
            break;
        case 5: {
            action = AddTaskContentAction;
            [parameters setValue:modifyStr forKey:@"content"];
        }
            break;
        default:
            break;
    }
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        if ([delegate respondsToSelector:@selector(comebackNetValue:)]) {
            [delegate comebackNetValue:dic];
        }
        
    } failure:^{}];
    
}

@end
