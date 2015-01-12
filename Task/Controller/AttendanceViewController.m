//
//  AttendanceViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendanceDetailViewController.h"

@interface AttendanceViewController (){
    NSString *attendanceType;
    NSTimer *changeCurrentTimer;
    
    int isShareAttendance;                        // 0 表示点击按钮，1表示摇一摇
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
    isShareAttendance = 0;
    [self setTableFooterView:self.mainTableView];
    [self initLocation];
    changeCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(changecurrentTime) userInfo:nil repeats:true];
    [changeCurrentTimer fire];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAddressInfo)];
    [locationLabel addGestureRecognizer:tapGestureRecognizer];

    // 设置考勤列表Label信息
    attendanceTime = [[NSDate date] dateToStringWithDateFormat:@"yyyy-MM"];
    myAttendanceListLabel.text = [NSString stringWithFormat:@"我的 %@ 的考勤信息", attendanceTime];

    // 判断考勤按钮
    [self judgeAttendanceBtn:[userInfo gainUserAttendance]];

    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        self.noneAttendanceDataLabel.hidden = true;
        [self gainAttendanceInfo];
    }];

    [self gainAttendanceInfo];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

- (void)changecurrentTime {
    // 设置日期
    currentTimeLabel.text = [[NSDate date] dateToStringWithDateFormat:@"MM-dd hh:mm"];
}

- (void)judgeAttendanceBtn:(NSString *)attendanceTypeBtn {
    if ([attendanceTypeBtn isEqualToString:@"0"]) {
        self.signInBtn.hidden = false;
        self.signOutBtn.hidden = true;
        attendanceType = @"1";
    } else if ([attendanceTypeBtn isEqualToString:@"1"] || [attendanceTypeBtn isEqualToString:@"2"]) {
        attendanceType = @"0";
        self.signInBtn.hidden = true;
        self.signOutBtn.hidden = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    if ([segue.identifier isEqualToString:@"GainToAttendanceDetailView"]) {
//        NSIndexPath *indexPath = [mainTableView indexPathForSelectedRow];
//        
//        AttendanceDetailViewController *attendanceDetailViewController = [segue destinationViewController];
//        attendanceDetailViewController.attendanceInfo = [attendanceArr objectAtIndex:indexPath.row];
//    }
//}


#pragma mark - 定位
-(void)initLocation {
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate = self;
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
    isShareAttendance = 0;
    attendanceType = @"1";
    [self createSelectAttendanceAlertView];
}

- (IBAction)signOutAttendance:(id)sender {
    if ([address isEqualToString:@""] || address == nil) {
        [self createSimpleAlertView:@"抱歉" msg:@"您尚未定位"];
        return ;
    }
    
    isShareAttendance = 0;
    [self createSelectAttendanceAlertView];
    attendanceType = @"0";
}

// 摇一摇
#pragma mark - Shake 摇一摇

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        //在此处实现摇一摇的功能
        if ([address isEqualToString:@""] || address == nil) {
            [self createSimpleAlertView:@"抱歉" msg:@"您尚未定位"];
            return ;
        }
        isShareAttendance = 1;
        attendancePatten = @"3";
        [self submitQRCodeAttendance:nil];
    }
}



- (void)createSelectAttendanceAlertView {
    BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:@"提示" message:@"请选择考勤的方式" subView:nil viewController:self];
    RIButtonItem *attendanceItem = [RIButtonItem itemWithLabel:@"二维码" action:^() {
        attendancePatten = @"1";
        [self gotoQRCodeViewController];
    }];
    [alertView addButton:attendanceItem type:RIButtonItemType_Other];
    
    RIButtonItem *locationItem = [RIButtonItem itemWithLabel:@"外  勤" action:^(){
        // 外 勤
        [self gotoLocationViewController];
    }];
    [alertView addButton:locationItem type:RIButtonItemType_Other];
    [alertView show];
}

// 二维码考勤
- (void)gotoQRCodeViewController {
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;

    [self presentViewController:reader animated:YES completion:NULL];
}

// 二维码考勤返回数据
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        [self submitQRCodeAttendance:result];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// 外勤
- (void)gotoLocationViewController {
    LocationAttendanceViewController *locationAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationAttendanceViewController"];
    locationAttendanceViewController.attendancePatten = @"2";
    locationAttendanceViewController.attendanceType = attendanceType;
    locationAttendanceViewController.address = address;
    locationAttendanceViewController.coordinate = coordinate;
    [self.navigationController pushViewController:locationAttendanceViewController animated:true];
}

// 考勤
- (void)submitQRCodeAttendance:(NSString *)description  {
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    [self.view.window showHUDWithText:@"正在考勤..." Type:ShowLoading Enabled:YES];
    //参数
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"type": attendanceType, @"pattern":attendancePatten, @"longitude": [NSString stringWithFormat:@"%f", coordinate.longitude], @"latitude": [NSString stringWithFormat:@"%f", coordinate.latitude], @"address":address, @"phoneImei": @"123"}];
    
    if (isShareAttendance == 0) {
        [parameters setObject:description forKey:@"description"];
    }else {
    }
    
    [self createAsynchronousRequest:AttendanceAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithNetManageResult: dic];
    } failure:^{}];
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
            [self judgeAttendanceBtn:@"1"];
            [self gainAttendanceInfo];
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
    } failure:^{
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
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
            if ([attendanceArr isEqualToArray:@[]]) {
                self.noneAttendanceDataLabel.hidden = false;
                [self.view bringSubviewToFront:self.noneAttendanceDataLabel];
            }else {
                self.noneAttendanceDataLabel.hidden = true;
            }
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
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
    cell.attendanceDescLabel.text = [NSString stringWithFormat:@"%@：%@",[dic objectForKey:@"date"], [self setCellRowsString:[dic objectForKey:@"address"]]];
    cell.attendanceTypeLabel.text = [dic objectForKey:@"type"];
    
    return cell;
}

- (id)setCellRowsString:(id)rowName {
    if ([rowName isKindOfClass:[NSString class]]) {
        return rowName;
    } else if ([rowName isKindOfClass:[NSArray class]]) {
        NSArray *arr = rowName;
        return [arr[0] dictionaryToString];
    }
    NSDictionary *dic = rowName;
    return [dic dictionaryToString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary *dic = [attendanceArr objectAtIndex:indexPath.row];
    
    NSString *msg = @"";
    msg = [msg stringByAppendingFormat:@"考勤地址:%@\n", [self setCellRowsString:[dic objectForKey:@"address"]]];
    msg = [msg stringByAppendingFormat:@"考勤描述:%@\n", [self setCellRowsString:[dic objectForKey:@"desc"]]];
    msg = [msg stringByAppendingFormat:@"考勤时间:%@\n", [self setCellRowsString:[dic objectForKey:@"date"]]];
    msg = [msg stringByAppendingFormat:@"考勤状态:%@\n", [self setCellRowsString:[dic objectForKey:@"type"]]];
    [self showAttendanceInfo:msg];
}

- (void)showAttendanceInfo:(NSString *)msg {
    BOAlertController *alertView = [[BOAlertController alloc] initWithTitle:@"考勤详情" message:msg subView:nil viewController:self];
    
    RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^{}];
    [alertView addButton:okItem type:RIButtonItemType_Other];
    
    [alertView show];
}

#pragma mark - 选择考勤时间
- (IBAction)selectAttendanceTime:(id)sender {
    [self createSheetWithSelectTime];
}

- (UIDatePicker *)createDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    
    return datePicker;
}

- (void)createSheetWithSelectTime {
    UIDatePicker *datePicker = [self createDatePicker];
    
    BOAlertController *actionSheet = [[BOAlertController alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil subView:datePicker viewController:self];
    
    RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        attendanceTime = [[datePicker date] dateToStringWithDateFormat:@"yyyy-MM"];
        if (![attendanceTime isEqualToString:myAttendanceListLabel.text]) {
            myAttendanceListLabel.text = myAttendanceListLabel.text = [NSString stringWithFormat:@"我的 %@ 的考勤信息", attendanceTime];
            [self gainAttendanceInfo];
        }
    }];
    [actionSheet addButton:okItem type:RIButtonItemType_Cancel];
    
    [actionSheet showInView:self.view];
}

@end