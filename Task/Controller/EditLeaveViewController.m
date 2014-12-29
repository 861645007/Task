//
//  EditLeaveViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "EditLeaveViewController.h"

@interface EditLeaveViewController () {
    NSString *approvePersonIdList;
}

@end

@implementation EditLeaveViewController
@synthesize titleStr;
@synthesize sickLeaveBtn;
@synthesize affairLeaveBtn;
@synthesize otherLaeveBtn;
@synthesize leaveReasonTextView;
@synthesize startTimeBtn;
@synthesize endTimeBtn;
@synthesize gainApprovePersonBtn;
@synthesize leaveApproveIds;
@synthesize leaveApproveNames;
@synthesize leaveContent;
@synthesize leaveEndTime;
@synthesize leaveId;
@synthesize leaveStartTime;
@synthesize leaveType;
@synthesize isAddNewLeave;

#pragma mark - 函数开始
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = titleStr;
    leaveReasonTextView.layer.borderWidth = 0.5;
    
    if (isAddNewLeave == 1) {
        leaveReasonTextView.text = leaveContent;
        [startTimeBtn setTitle:leaveStartTime forState:UIControlStateNormal];
        [endTimeBtn setTitle:leaveEndTime forState:UIControlStateNormal];
        [gainApprovePersonBtn setTitle:leaveApproveNames forState:UIControlStateNormal];
        gainApprovePersonBtn.tag = 1;
        startTimeBtn.tag = 1;
        endTimeBtn.tag = 1;
        approvePersonIdList = leaveApproveIds;
        [self setOldLeaveType:leaveType];
    }
}

// 设置编辑之前的请假类型
- (void)setOldLeaveType:(NSString *)oldLavetype {
    if ([oldLavetype isEqualToString:@"事假"]) {
        affairLeaveBtn.tag = 1;
        [self setSelectImageView:affairLeaveBtn];
    }else if ([oldLavetype isEqualToString:@"病假"]) {
        sickLeaveBtn.tag = 1;
        [self setSelectImageView:sickLeaveBtn];
    }else if ([oldLavetype isEqualToString:@"其他"]) {
        otherLaeveBtn.tag = 1;
        [self setSelectImageView:otherLaeveBtn];
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

#pragma mark - 选择请假类型
- (IBAction)selectSickLeave:(id)sender {
    if (sickLeaveBtn.tag == 0) {
        sickLeaveBtn.tag = 1;
        affairLeaveBtn.tag = 0;
        otherLaeveBtn.tag = 0;
        [self setBtnImage];
    }
}

- (IBAction)selectAffairLeave:(id)sender {
    if (affairLeaveBtn.tag == 0) {
        affairLeaveBtn.tag = 1;
        sickLeaveBtn.tag = 0;
        otherLaeveBtn.tag = 0;
        [self setBtnImage];
    }
}

- (IBAction)selectOtherLeave:(id)sender {
    if (otherLaeveBtn.tag == 0) {
        otherLaeveBtn.tag = 1;
        affairLeaveBtn.tag = 0;
        sickLeaveBtn.tag = 0;
        [self setBtnImage];
    }
}

// 重新设置三个按钮的图片
- (void)setBtnImage {
    [self hiddenKeyboard];
    [self setSelectImageView:sickLeaveBtn];
    [self setSelectImageView:affairLeaveBtn];
    [self setSelectImageView:otherLaeveBtn];
}

// 设置按钮的图片
- (void)setSelectImageView:(UIButton *)btn {
    if (btn.tag == 0) {
        [btn setImage:[UIImage imageNamed:@"select_item_unchecked"] forState:UIControlStateNormal];
    } else if (btn.tag == 1) {
        [btn setImage:[UIImage imageNamed:@"select_item_checked"] forState:UIControlStateNormal];
    }
}

#pragma mark - 选择时间
- (IBAction)selectStartTime:(id)sender {
    [self hiddenKeyboard];
    [self createSheetWithSelectTime: (UIButton *)sender];
}

- (IBAction)selectEndTIme:(id)sender {
    [self hiddenKeyboard];
    [self createSheetWithSelectTime: (UIButton *)sender];
}

- (UIDatePicker *)createDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.date = [NSDate date];
    
    return datePicker;
}

- (void)createSheetWithSelectTime:(UIButton *)btn {
    UIDatePicker *datePicker = [self createDatePicker];
    
    BOAlertController *actionSheet = [[BOAlertController alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil subView:datePicker viewController:self];
    
    RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        btn.tag = 1;
        NSString *dateStr = [[datePicker date] dateToStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [btn setTitle:dateStr forState:UIControlStateNormal];
    }];
    [actionSheet addButton:okItem type:RIButtonItemType_Cancel];
    
    [actionSheet showInView:self.view];
}

#pragma  mark - 选择审批人
- (IBAction)gainApprovePerson:(id)sender {
    SelectHeaderViewController *selected = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectHeaderViewController"];
    selected.viewTitle = @"审批人";
    selected.delegate  = self;
    selected.isRadio   = 1;
    [self.navigationController pushViewController:selected animated:YES];
}

#pragma mark - SelectedHeaderProtocol
- (void)selectedHeader:(NSArray *)headerList {
    NSString *headerIdListStr = @"";
    NSString *headerNameListStr = @"";
    for (NSDictionary *dic in headerList) {
        if ([dic isEqual:[headerList lastObject]]) {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"employeeId"]];
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"realName"]];
        }else {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"employeeId"]];
            headerNameListStr = [headerNameListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"realName"]];
        }
    }
    
    [self.gainApprovePersonBtn setTitle:headerNameListStr forState:UIControlStateNormal];
    approvePersonIdList = headerIdListStr;
    gainApprovePersonBtn.tag = 1;
}

#pragma mark - 保存
- (IBAction)saveLeaveInfo:(id)sender {
    // 判断是否选择了请假类型
    if (sickLeaveBtn.tag == 0 && affairLeaveBtn.tag == 0 && otherLaeveBtn.tag == 0) {
        [self createSimpleAlertView:@"抱歉" msg:@"请选择请假类型"];
        return ;
    }
    
    // 判断是否填写了请假原因
    if ([leaveReasonTextView.text isEqual: @""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请填写请假原因"];
        return ;
    }
    
    // 判断选择了请假时间
    if (startTimeBtn.tag == 0 || endTimeBtn.tag == 0) {
        [self createSimpleAlertView:@"抱歉" msg:@"请选择请假时间"];
        return ;
    }
    
    // 判断选择了请假时间
    if (gainApprovePersonBtn.tag == 0) {
        [self createSimpleAlertView:@"抱歉" msg:@"请选择审批人"];
        return ;
    }

    [self submitLeaveInfo];
}

// 获取数据
- (void)submitLeaveInfo {
    [self.view.window showHUDWithText:@"正在请假..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    // 判断请假类型
    NSString *newleaveType;
    if (sickLeaveBtn.tag == 1) {
        newleaveType = @"病假";
    } else if (affairLeaveBtn.tag == 1) {
        newleaveType = @"事假";
    }else if (otherLaeveBtn.tag == 1) {
        newleaveType = @"其他";
    }
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"type": newleaveType, @"comment":leaveReasonTextView.text, @"startTime": startTimeBtn.titleLabel.text, @"endTime": endTimeBtn.titleLabel.text, @"approveIds": approvePersonIdList}];
    
    if (isAddNewLeave == 1) {
        [parameters setObject:leaveId forKey:@"leaveId"];
    }
    
    [self createAsynchronousRequest:AddLeaveAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithSubmitLeaveInfoResult: dic];
    } failure:^{}];
}

//处理网络操作结果
- (void)dealWithSubmitLeaveInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"请假成功" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 隐藏键盘
- (IBAction)hidenKeyboard:(id)sender {
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard {
    [leaveReasonTextView resignFirstResponder];
}
@end
