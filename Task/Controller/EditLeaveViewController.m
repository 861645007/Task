//
//  EditLeaveViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "EditLeaveViewController.h"
#import "AddLeaveAccessaryTableViewCell.h"
#import "PreviewFileViewController.h"
#import "PreviewLeaveAccessaryViewController.h"

@interface EditLeaveViewController () {
    NSString *approvePersonIdList;
    NSMutableArray *accessaryList;
    int submitImageIndex;
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
@synthesize selectedAccessaryBtn;
@synthesize leaveApproveIds;
@synthesize leaveApproveNames;
@synthesize leaveContent;
@synthesize leaveEndTime;
@synthesize leaveId;
@synthesize leaveStartTime;
@synthesize leaveType;
@synthesize isAddNewLeave;
@synthesize accessaryTableView;
@synthesize leaveAccessaryList;


#pragma mark - 函数开始
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = titleStr;
    leaveReasonTextView.layer.borderWidth = 0.5;
    [self setTableFooterView:accessaryTableView];
    
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
    
    if (leaveAccessaryList == nil || [leaveAccessaryList count] == 0) {
        accessaryList = [NSMutableArray array];
    }else {
        accessaryList = [NSMutableArray arrayWithArray:leaveAccessaryList];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GainPreviewLeaveAccessaryView"]) {
        NSIndexPath *indexPath = [accessaryTableView indexPathForSelectedRow];
        
        PreviewLeaveAccessaryViewController *previewLeaveAccessaryViewController = [segue destinationViewController];
        UIImage *image = [[accessaryList objectAtIndex:indexPath.row] objectForKey:@"image"];
        previewLeaveAccessaryViewController.previewImageData = UIImagePNGRepresentation(image);
    }
}


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

#pragma mark - 选择附件
- (IBAction)selectedAccessary:(id)sender {
    [self clickTaskAccessorysBtn];
}

// 选取照片
- (void)clickTaskAccessorysBtn {
    BOAlertController *sheetAction = [[BOAlertController alloc] initWithTitle:@"请选择上传附件方式" message:nil subView:nil viewController:self];
    RIButtonItem *cameraItem = [RIButtonItem itemWithLabel:@"拍照获取" action:^(){
        [self pickImageFromCamera];
    }];
    [sheetAction addButton:cameraItem type:RIButtonItemType_Other];
    
    RIButtonItem *albumItem = [RIButtonItem itemWithLabel:@"相册获取" action:^(){
        [self pickImageFromAlbum];
    }];
    [sheetAction addButton:albumItem type:RIButtonItemType_Other];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^(){}];
    [sheetAction addButton:cancelItem type:RIButtonItemType_Cancel];
    
    [sheetAction showInView:self.view];
}

#pragma mark - 从相册获取
- (void)pickImageFromAlbum {
    RBImagePickerController *imagePicker = [[RBImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.dataSource = self;
    imagePicker.selectionType = RBMultipleImageSelectionType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)pickImageFromCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        NSLog(@"你这是模拟器！");
    }
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

#pragma mark RBImagePickerDataSource
-(NSInteger)imagePickerControllerMaxSelectionCount:(RBImagePickerController *)imagePicker {
    return 9;
}

-(NSInteger)imagePickerControllerMinSelectionCount:(RBImagePickerController *)imagePicker {
    return 0;
}

#pragma mark RBImagePickerDelegate
-(void)imagePickerController:(RBImagePickerController *)imagePicker didFinishPickingImagesList:(NSArray *)imageList {
    [self addNewAccessary:imageList];
}

-(void)imagePickerControllerDoneCancel:(RBImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self addNewAccessary:@[image]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)addNewAccessary:(NSArray *)imageList {
    for (int i = 0; i < [imageList count]; i++) {
        UIImage *image = [imageList objectAtIndex:i];
        NSString *imageName = [NSString stringWithFormat:@"%@-%d.png", [[NSDate date] dateToStringWithDateFormat:@"hh-mm-ss"], i];
        [accessaryList addObject:@{@"name": imageName, @"image": image}];
    }

    [accessaryTableView reloadData];
}

#pragma mark - 提交请假
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
            if ([accessaryList count] == 0) {
                [self.view.window showHUDWithText:@"请假成功" Type:ShowPhotoYes Enabled:YES];
                [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            }else {
                submitImageIndex = 0;
                if (isAddNewLeave) {
                    [self submitReportImage:[[accessaryList objectAtIndex:0] objectForKey:@"image"] leaveAccessaryId:leaveId imageName:[[accessaryList objectAtIndex:0] objectForKey:@"name"]];
                }else {
                    [self submitReportImage:[[accessaryList objectAtIndex:0] objectForKey:@"image"] leaveAccessaryId:[dic objectForKey:@"leaveId"] imageName:[[accessaryList objectAtIndex:0] objectForKey:@"name"]];
                }
            }
            
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

// 上传图片
- (void)submitReportImage:(UIImage *)sImage leaveAccessaryId:(NSString *)leaveIdForAccessary imageName:(NSString *)imageName {
    NSDictionary *accessaryDic = [accessaryList objectAtIndex:submitImageIndex];
    if (![[NSString stringWithFormat:@"%@", [accessaryDic objectForKey:@"accessoryId"]] isEqualToString:@"(null)"]) {
        if (submitImageIndex == [accessaryList count] - 1) {
            [self.view.window showHUDWithText:@"请假完成" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            return ;
        }
        int index = ++submitImageIndex;
        [self submitReportImage:[[accessaryList objectAtIndex:index] objectForKey:@"image"] leaveAccessaryId:leaveIdForAccessary imageName:[[accessaryList objectAtIndex:index] objectForKey:@"name"]];
        return ;
    }
    
    [self.view.window showHUDWithText:@"正在请假..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSData *imageData = UIImageJPEGRepresentation(sImage, 0.30);
   
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"leaveId": leaveIdForAccessary}];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",HttpURL, AddLeaveAccessoryAction] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:imageName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (submitImageIndex == [accessaryList count] - 1) {
            [self.view.window showHUDWithText:@"请假完成" Type:ShowPhotoYes Enabled:YES];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
        }else {
            int index = ++submitImageIndex;
            [self submitReportImage:[[accessaryList objectAtIndex:index] objectForKey:@"image"] leaveAccessaryId:leaveIdForAccessary imageName:[[accessaryList objectAtIndex:index] objectForKey:@"name"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取服务器响应出错");
    }];
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [accessaryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"AddLeaveAccessaryTableViewCell";
    AddLeaveAccessaryTableViewCell *cell = (AddLeaveAccessaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddLeaveAccessaryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dic = [accessaryList objectAtIndex:indexPath.row];
    cell.accessarySizeLabel.hidden = YES;
    NSString *accessaryId = [self judgeTextIsNULL:[NSString stringWithFormat:@"%@", [dic objectForKey:@"accessoryId"]]];
    if ([accessaryId isEqualToString:@"(null)"]) {
        cell.accessaryNameLabel.text = [dic objectForKey:@"name"];
        [cell.deleteAccessaryBtn addTarget:self action:@selector(deleteAccessary:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteAccessaryBtn.tag = indexPath.row;
    }else {
        cell.accessaryNameLabel.text = [dic objectForKey:@"accessoryName"];
        cell.deleteAccessaryBtn.hidden = YES;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *accessAryDic = [accessaryList objectAtIndex:indexPath.row];
    NSString *accessaryId = [self judgeTextIsNULL:[NSString stringWithFormat:@"%@", [accessAryDic objectForKey:@"accessoryId"]]];
    if ([accessaryId isEqualToString:@"(null)"]) {
        PreviewLeaveAccessaryViewController *previewLeaveAccessaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewLeaveAccessaryViewController"];
        UIImage *image = [[accessaryList objectAtIndex:indexPath.row] objectForKey:@"image"];
        previewLeaveAccessaryViewController.previewImageData = UIImagePNGRepresentation(image);
        [self.navigationController pushViewController:previewLeaveAccessaryViewController animated:YES];
        
    }else {
        PreviewFileViewController *previewFileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewFileViewController"];
        previewFileViewController.isTaskOrReportAccessory = 2;
        previewFileViewController.accessoryId = [accessAryDic objectForKey:@"accessoryId"];
        previewFileViewController.fileName = [accessAryDic objectForKey:@"accessoryTempName"];
        [self.navigationController pushViewController:previewFileViewController animated:YES];
    }
}

- (void)deleteAccessary:(UIButton *)btn {
    [accessaryList removeObjectAtIndex:btn.tag];
    
    [self.accessaryTableView reloadData];
}


#pragma mark - 隐藏键盘
- (IBAction)hidenKeyboard:(id)sender {
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard {
    [leaveReasonTextView resignFirstResponder];
}
@end

