//
//  LocationAttendanceViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/17.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LocationAttendanceViewController.h"
#import "LocationAttendanceCollectionViewCell.h"

@interface LocationAttendanceViewController () {
    NSMutableArray *selectedImageArr;
    NSInteger submitImageIndex;
}


@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;


@end

@implementation LocationAttendanceViewController
@synthesize attendancePatten;
@synthesize coordinate;
@synthesize commentTextView;
@synthesize attendanceType;
@synthesize address;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    commentTextView.layer.borderWidth = 0.5;
    selectedImageArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"document_add"]];
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

#pragma mark - Collection View
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [selectedImageArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LocationAttendanceCell";
    LocationAttendanceCollectionViewCell *locationAttendanceCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    locationAttendanceCell.selectedImageView.image = [selectedImageArr objectAtIndex:indexPath.row];
    return locationAttendanceCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([selectedImageArr count] - 1)) {
        [self selectedImage];
    }
}

- (void)selectedImage {
    [self pickImageFromCamera];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self addImageToSelectd:@[image]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 添加照片
- (void)addImageToSelectd:(NSArray *)imageArr {
    UIImage *lastImage = [[selectedImageArr lastObject] copy];
    [selectedImageArr removeLastObject];
    for (UIImage *image in imageArr) {
        [selectedImageArr addObject:image];
    }
    [selectedImageArr addObject:lastImage];
    
    [self.imageCollectionView reloadData];
}


#pragma mark - 提交外勤
- (IBAction)sureAttendance:(id)sender {
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:@"请输入考勤信息"];
        return ;
    }
    
    [self signInAttendance];
}

- (IBAction)hiddenKeyboard:(id)sender {
    [self.commentTextView resignFirstResponder];
}

// 考勤
- (void)signInAttendance{
    [self.view.window showHUDWithText:@"正在考勤" Type:ShowLoading Enabled:true];
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"type": attendanceType, @"pattern":attendancePatten, @"longitude": [NSString stringWithFormat:@"%f", coordinate.longitude], @"latitude": [NSString stringWithFormat:@"%f", coordinate.latitude], @"address":address, @"phoneImei": @"123", @"description": commentTextView.text};
    
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
            if ([selectedImageArr count] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAttendanceState" object:@"1"];
                [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            }else {
                submitImageIndex = 0;
                // 开始上传图片
                [self submitReportImage:[selectedImageArr objectAtIndex:0] attendanceId:[self judgeTextIsNULL:[dic objectForKey:@"attendanceId"]]];
            }
            
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

// 上传图片
- (void)submitReportImage:(UIImage *)sImage attendanceId:(NSString *)attendanceId {
    [self.view.window showHUDWithText:@"上传中..." Type:ShowLoading Enabled:YES];
    
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSData *imageData = UIImageJPEGRepresentation(sImage, 0.30);
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"attendanceId": attendanceId}];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",HttpURL, AttendanceImageAction] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [[NSDate date] dateToStringWithDateFormat:@"hh-mm-ss"]];
        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (submitImageIndex == [selectedImageArr count] - 2) {
            [self.view.window showHUDWithText:@"上传完成" Type:ShowPhotoYes Enabled:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAttendanceState" object:@"1"];
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
        }else {
            [self submitReportImage:selectedImageArr[++submitImageIndex] attendanceId:attendanceId];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取服务器响应出错");
    }];
}


- (void)comeBack {
    [self.navigationController popViewControllerAnimated:true];
}

@end
