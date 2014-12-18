//
//  AttendanceViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AttendanceViewController.h"

@interface AttendanceViewController (){
    NSString *attendanceType;
    NSString *attendancePatten;
    CLLocationCoordinate2D coordinate;
    NSString *address;
    NSString *attendanceTime;
    NSMutableArray *attendanceArr;
}

@end

@implementation AttendanceViewController
@synthesize locationLabel;
@synthesize noneAttendanceDataLabel;
@synthesize myAttendanceListLabel;
@synthesize mainTableView;
@synthesize signInBtn;
@synthesize signOutBtn;
@synthesize currentTimeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    attendanceArr = [NSMutableArray array];
    [self initLocation];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAddressInfo)];
    [locationLabel addGestureRecognizer:tapGestureRecognizer];
    
    // 设置日期
    currentTimeLabel.text = [[NSDate date] dateToStringWithDateFormat:@"MM-dd hh:mm"];
    
    // 设置考勤列表Label信息
    attendanceTime = [[NSDate date] dateToStringWithDateFormat:@"yyyy-MM"];
    myAttendanceListLabel.text = [NSString stringWithFormat:@"我的 %@ 的考勤信息", attendanceTime];
    
    // 判断考勤按钮
    [self judgeAttendanceBtn:[userInfo gainUserAttendance]];
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainAttendanceInfo];
    }];

    [self gainAttendanceInfo];
}

- (void)judgeAttendanceBtn:(NSString *)attendanceTypeBtn {
    if ([attendanceTypeBtn isEqualToString:@"0"]) {
        self.signInBtn.hidden = false;
        self.signOutBtn.hidden = true;
    } else if ([attendanceTypeBtn isEqualToString:@"1"] || [attendanceTypeBtn isEqualToString:@"2"]) {
        self.signInBtn.hidden = true;
        self.signOutBtn.hidden = false;
    }
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

#pragma mark - 定位
-(void)initLocation {
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

//获取地址
- (void)getAddressInfo {
    locationLabel.text = LocationLoading;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新  开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"请开启定位功能！");
    }
}

//CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 停止位置更新
    [manager stopUpdatingLocation];
    CLLocation *locationGCJ = [newLocation locationMarsFromEarth];
    coordinate = locationGCJ.coordinate;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locationGCJ completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            locationLabel.text = placemark.name;
            address = placemark.name;
            self.locationImageView.image = [UIImage imageNamed:@"ic_locus_pressed"];
        }
    }];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view.window showHUDWithText:@"定位失败" Type:ShowPhotoNo Enabled:YES];
    self.locationImageView.image = [UIImage imageNamed:@"ic_locus"];
    locationLabel.text = LocationNO;
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}


#pragma mark - 考勤操作
- (IBAction)signAttendance:(id)sender {
    if ([address isEqualToString:@""] || address == nil) {
        [self createSimpleAlertView:@"抱歉" msg:@"您尚未定位"];
        return ;
    }
    
    attendanceType = @"1";
    [self createSelectAttendanceAlertView];
}

- (IBAction)signOutAttendance:(id)sender {
    if ([address isEqualToString:@""] || address == nil) {
        [self createSimpleAlertView:@"抱歉" msg:@"您尚未定位"];
        return ;
    }
    
    [self createSelectAttendanceAlertView];
    attendanceType = @"0";
}

- (void)createSelectAttendanceAlertView {
    BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请选择考勤的方式" subView:nil viewController:self];
    RIButtonItem *attendanceItem = [RIButtonItem itemWithLabel:@"二维码" action:^() {
        attendancePatten = @"1";
        ReadQRCodeViewController *readQRCodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadQRCodeViewController"];
        readQRCodeViewController.delegate = self;
        [self.navigationController pushViewController:readQRCodeViewController animated:true];
    }];
    [alertView addButton:attendanceItem type:RIButtonItemType_Other];
    
    RIButtonItem *locationItem = [RIButtonItem itemWithLabel:@"外  勤" action:^(){
        // 外 勤
        [self gotoLocationViewController];
    }];
    [alertView addButton:locationItem type:RIButtonItemType_Other];
    [alertView show];
}

- (void)gotoLocationViewController {
    LocationAttendanceViewController *locationAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAttendanceViewController"];
    locationAttendanceViewController.attendancePatten = @"2";
    locationAttendanceViewController.attendanceType = attendanceType;
    locationAttendanceViewController.address = address;
    locationAttendanceViewController.coordinate = coordinate;
    [self.navigationController pushViewController:locationAttendanceViewController animated:true];
}

// 二维码考勤返回数据
- (void)comebackValeue:(id)value {
    [self submitQRCodeAttendance:value];
}

// 考勤
- (void)submitQRCodeAttendance:(NSString *)description  {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"type": attendanceType, @"pattern":attendancePatten, @"longitude": [NSString stringWithFormat:@"%f", coordinate.longitude], @"latitude": [NSString stringWithFormat:@"%f", coordinate.latitude], @"address":address, @"phoneImei": @"123", @"description": description};
    
    [self createAsynchronousRequest:AttendanceAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithNetManageResult: dic];
    }];
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
            [self.view.window showHUDWithText:@"考勤成功" Type:ShowPhotoYes Enabled:YES];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

#pragma mark - 获取并展示签到数据
- (void)gainAttendanceInfo {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"date": attendanceTime};
    
    [self createAsynchronousRequest:AttendanceMonthAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainAttendanceInfoResult: dic];
    }];
}

//处理网络操作结果
- (void)dealWithGainAttendanceInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            self.noneAttendanceDataLabel.hidden = false;
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取考勤成功" Type:ShowPhotoYes Enabled:YES];
            attendanceArr = [dic objectForKey:@"list"];
            [self.mainTableView reloadData];
            if ([[dic objectForKey:@"list"] isEqualToArray:@[]]) {
                self.noneAttendanceDataLabel.hidden = false;
            }else {
                self.noneAttendanceDataLabel.hidden = true;
            }
            // 事情做完了, 结束刷新动画~~~
            [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [attendanceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"AttendanceListCell";
    AttendanceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dic = [attendanceArr objectAtIndex:indexPath.row];
    cell.attendanceDescLabel.text = [NSString stringWithFormat:@"%@：%@",[dic objectForKey:@"date"], [self setCellRowsString:[dic objectForKey:@"desc"]]];
    cell.attendanceTypeLabel.text = [dic objectForKey:@"type"];
    
    return cell;
}

- (id)setCellRowsString:(id)rowName {
    if ([rowName isKindOfClass:[NSString class]]) {
        return rowName;
    }
    NSDictionary *dic = rowName;
    return [dic dictionaryToString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - 选择考勤时间
- (IBAction)selectAttendanceTime:(id)sender {
    [self createSheetWithSelectTime];
}

- (UIDatePicker *)createDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.date = [NSDate date];
    
    return datePicker;
}

- (void)createSheetWithSelectTime {
    UIDatePicker *datePicker = [self createDatePicker];
    
    BOAlertController *actionSheet = [[BOAlertController alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil subView:datePicker viewController:self];
    
    RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        attendanceTime = [[datePicker date] dateToStringWithDateFormat:@"yyyy-MM"];
        myAttendanceListLabel.text = myAttendanceListLabel.text = [NSString stringWithFormat:@"我的 %@ 的考勤信息", attendanceTime];
    }];
    [actionSheet addButton:okItem type:RIButtonItemType_Destructive];
    
    [actionSheet showInView:self.view];
}

@end