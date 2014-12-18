//
//  AttendanceViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadQRCodeViewController.h"
#import "LocationAttendanceViewController.h"
#import "AttendanceListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

#define LocationNO @"尚未定位(点击定位)"
#define LocationLoading @"正在定位中..."

@interface AttendanceViewController : BaseViewController<CLLocationManagerDelegate, ComebackValueProtocol, UITableViewDataSource, UITableViewDelegate> {
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *noneAttendanceDataLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *myAttendanceListLabel;

- (IBAction)showMenu:(id)sender;
- (IBAction)signAttendance:(id)sender;
- (IBAction)signOutAttendance:(id)sender;
- (IBAction)selectAttendanceTime:(id)sender;

@end
