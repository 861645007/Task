//
//  AttendanceDetailViewController.h
//  Task
//
//  Created by wanghuanqiang on 15/1/5.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface AttendanceDetailViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *attendanceInfo;

@property (weak, nonatomic) IBOutlet UILabel *attendanceDetailPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendanceDetailTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendanceDetailDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendanceDetailTypeLabel;

@end
