//
//  AttendanceDetailViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/5.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "AttendanceDetailViewController.h"

@interface AttendanceDetailViewController ()

@end

@implementation AttendanceDetailViewController
@synthesize attendanceDetailDescLabel;
@synthesize attendanceDetailPersonNameLabel;
@synthesize attendanceDetailTimeLabel;
@synthesize attendanceDetailTypeLabel;
@synthesize attendanceInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    attendanceDetailDescLabel.text = [attendanceInfo objectForKey:@"desc"];
    attendanceDetailPersonNameLabel.text = [userInfo gainUserName];
    attendanceDetailTimeLabel.text = [attendanceInfo objectForKey:@"date"];
    attendanceDetailTypeLabel.text = [attendanceInfo objectForKey:@"type"];
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

@end
