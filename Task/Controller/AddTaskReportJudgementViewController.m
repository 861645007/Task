//
//  AddTaskReportJudgementViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AddTaskReportJudgementViewController.h"

@interface AddTaskReportJudgementViewController () {
    NSMutableArray *selectedImageArr;
    int submitImageIndex;
}

@end

@implementation AddTaskReportJudgementViewController
@synthesize mainCollectionView;
@synthesize photoBtn;
@synthesize cameraBtn;
@synthesize promptLabel;
@synthesize reportJudgementTextView;
@synthesize titleStr;
@synthesize isFeedBackOrJudgement;
@synthesize taskId;
@synthesize taskReportId;
@synthesize judgedUserId;
@synthesize judgedUserName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"新的%@", titleStr];
    self.promptLabel.text = [NSString stringWithFormat:@"请输入新的%@", titleStr];
    
    selectedImageArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"document_add"]];    
    reportJudgementTextView.layer.borderWidth = 0.5;
    [reportJudgementTextView becomeFirstResponder];
    
    [self initCollectionCell];

    // 右上角添加提交 bar
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submitTaskFeedback)];
    self.navigationItem.rightBarButtonItem = saveBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionCell
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(70, 70)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.mainCollectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - CollentionView 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [selectedImageArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"taskJudgeCollectionViewCell";
    AddTaskReportJudgementCollectionViewCell *taskJudgeCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    taskJudgeCollectionViewCell.layer.cornerRadius = 6.0f;
    
    if ([[selectedImageArr objectAtIndex:indexPath.row] isEqual:[selectedImageArr lastObject]]) {
        taskJudgeCollectionViewCell.judgementImageView.image = [selectedImageArr objectAtIndex:indexPath.row];
    }
    else
    {
        taskJudgeCollectionViewCell.judgementImageView.image = [selectedImageArr objectAtIndex:indexPath.row];
    }
    
    return taskJudgeCollectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[selectedImageArr objectAtIndex:indexPath.row] isEqual:[selectedImageArr lastObject]]) {
        [self pickImageFromAlbum];
    }
}

#pragma mark - 获取图片操作

- (IBAction)getImageWithCamera:(id)sender {
    [self hidenKeyboard];
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

- (IBAction)getImageWithAlbum:(id)sender {
    [self pickImageFromAlbum];
}

- (void)pickImageFromAlbum {
    [self hidenKeyboard];
    GetAllPhotoCollectionViewController *allPhotoCollectionView = [GetAllPhotoCollectionViewController setCollectionViewController:4 delegate:self];
    [self.navigationController pushViewController:allPhotoCollectionView animated:YES];
}


#pragma mark - 从相册获取图片
- (void)selectedPhoto:(NSArray *)imageList {
    [self addImageToSelectd:imageList];
}

#pragma mark - 从照相机获取照片 image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [self.view.window showHUDWithText:@"提交附件" Type:ShowLoading Enabled:YES];
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
    
    [mainCollectionView reloadData];
}

#pragma mark - 保存操作
- (void)submitTaskFeedback {
    [self hidenKeyboard];
    
    if ([reportJudgementTextView.text isEqualToString:@""]) {
        [self createSimpleAlertView:@"抱歉" msg:[NSString stringWithFormat:@"请输入新的%@", titleStr]];
        return ;
    }
    [self.view.window showHUDWithText:@"上传中..." Type:ShowLoading Enabled:YES];
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSString *action = @"";
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId}];
    
    if (isFeedBackOrJudgement == 0) {
        action = AddTaskReportAction;
        [parameters setValue:taskId forKey:@"taskId"];
        [parameters setValue:reportJudgementTextView.text forKey:@"description"];
    }else {
        action = AddTaskReportJudgementAction;
        [parameters setValue:taskReportId forKey:@"taskReportId"];
        [parameters setValue:judgedUserId forKey:@"judgedUserId"];
        [parameters setValue:judgedUserName forKey:@"judgedUserName"];
        [parameters setValue:reportJudgementTextView.text forKey:@"content"];
    }
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithTaskFeedback:dic];
    } failure:^{}];
}

// 处理评论上传
- (void)dealWithTaskFeedback:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            if ([selectedImageArr count] == 1) {
                [self.view.window showHUDWithText:@"提交成功" Type:ShowPhotoYes Enabled:YES];
                [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
            }else {
                submitImageIndex = 0;
                if (isFeedBackOrJudgement == 0) {
                    [self submitReportImage:selectedImageArr[submitImageIndex] taskReportId:[dic objectForKey:@"taskReortId"]];
                }else {
                    [self submitReportImage:selectedImageArr[submitImageIndex] taskReportId:taskReportId];
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
- (void)submitReportImage:(UIImage *)sImage taskReportId:(NSString *)reportId {
    [self.view.window showHUDWithText:@"上传中..." Type:ShowLoading Enabled:YES];  
    
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    NSData *imageData = UIImageJPEGRepresentation(sImage, 0.30);
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"taskReportId": reportId}];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",HttpURL, AddTaskReportAccessoryAction] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
            [self performSelector:@selector(comeBack) withObject:nil afterDelay:0.9];
        }else {
            [self submitReportImage:selectedImageArr[++submitImageIndex] taskReportId:reportId];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取服务器响应出错");
    }];
}


- (void)comeBack {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - 隐藏键盘
- (IBAction)hiddenKeyboard:(id)sender {
    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    [reportJudgementTextView resignFirstResponder];
}
@end
