//
//  PreviewFileViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "PreviewFileViewController.h"

@interface PreviewFileViewController () {
    UIDocumentInteractionController *documentInteractionController;
    NSString *fileSavePath;
}

@end

@implementation PreviewFileViewController
@synthesize fileName;
@synthesize accessoryId;
@synthesize isTaskOrReportAccessory;
@synthesize isReportOrJudgeAccessory;
@synthesize toolVIew;
@synthesize loadingImageView;
@synthesize loadingProcessView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fileSavePath = [[CustomToolClass shareInstance] gainFilePath:fileName folderName:@"TaskAccessory"];
    
    loadingProcessView.progress = 0.0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileSavePath]) {
        [self dealWithSuccess];
    }else {
        [self downloadFile];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 下载文件 
- (void)downloadFile {
    NSString *folderName = @"";
    if (isTaskOrReportAccessory == 0) {
        folderName = @"taskAccessory";
    }else {
        if (isReportOrJudgeAccessory == 0) {
            folderName = @"taskReportAccessory";
        }else {
            folderName = @"taskReportJudgeAccessory";
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://vmr82ksj.zhy35065.zhihui.chinaccnet.cn/upload/%@/%@", folderName, fileName]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileSavePath append:NO];
    
    // 下载进度控制
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
         loadingProcessView.progress = (float)totalBytesRead/totalBytesExpectedToRead;
    }];
    
    // 已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 下载成功
        [self dealWithSuccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 下载失败
        loadingProcessView.hidden = YES;
        loadingImageView.hidden = NO;
        [self.view.window showHUDWithText:@"下载失败" Type:ShowPhotoNo Enabled:YES];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fileSavePath error:nil];
    }];
    
    [operation start];
}

- (void)dealWithSuccess {
    loadingProcessView.hidden = YES;
    loadingImageView.hidden = YES;
    
    NSString *pathExtension = [fileSavePath pathExtension];
    if ([pathExtension isEqualToString:@"png"] || [pathExtension isEqualToString:@"jpg"]) {
        UIImage *fileImage = [UIImage imageWithContentsOfFile:fileSavePath];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self gainImageFrame:fileImage.size]];
        imageView.image = fileImage;
        [self.view addSubview:imageView];
        [self.view bringSubviewToFront:toolVIew];
    }else {
        [self setImageViewWithSuccess];
        [self previewFile];
    }
    
    // 添加预览按钮
    UIBarButtonItem *previewBar = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewFile)];
    self.navigationItem.rightBarButtonItem = previewBar;
}

- (CGRect )gainImageFrame:(CGSize )imageSize {
    CGFloat viewH = self.view.frame.size.height;
    CGFloat viewW = self.view.frame.size.width;
    CGRect frame;
    
    CGFloat wHRatio = imageSize.width / imageSize.height;  // 图片的长宽比
    
    if (imageSize.width > viewW && imageSize.height >  viewH - 44) {
        if (imageSize.width > imageSize.height) {
            frame = CGRectMake(0, (viewH - viewW / wHRatio) / 2, viewW, viewW / wHRatio);
        }else {
            frame = CGRectMake((viewW - viewH * wHRatio) / 2, 64, viewH * wHRatio, viewH);
        }
    }else if (imageSize.width > viewW && imageSize.height <  viewH - 44) {
        frame = CGRectMake(0, (viewH - viewW / wHRatio) / 2, viewW, viewW / wHRatio);
    }else if (imageSize.width < viewW && imageSize.height >  viewH - 44) {
        frame = CGRectMake((viewW - viewH * wHRatio) / 2, 64, viewH * wHRatio, viewH);
    }else {
        frame = CGRectMake((viewW - imageSize.width) / 2, (viewH - imageSize.height) / 2, imageSize.width, imageSize.height);
    }
    
    return frame;
}

- (void)setImageViewWithSuccess {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) / 2, (self.view.frame.size.height - 50) / 2, 50, 50)];
    UIImage *image = nil;
    NSString *pathExtension = [fileSavePath pathExtension];
    if ([pathExtension isEqualToString:@"doc"] || [pathExtension isEqualToString:@"docx"]) {
        image = [UIImage imageNamed:@"DOCX"];
    }else if ([pathExtension isEqualToString:@"ppt"] || [pathExtension isEqualToString:@"pptx"]) {
        image = [UIImage imageNamed:@"PPT"];
    }else if ([pathExtension isEqualToString:@"txt"]) {
        image = [UIImage imageNamed:@"TXT"];
    }
    imageView.image = image;
    [self.view addSubview:imageView];
}

- (void)previewFile {
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileSavePath]];
    documentInteractionController.delegate = self;
    [documentInteractionController presentPreviewAnimated:YES];
}

#pragma amrk - 删除文件
- (IBAction)deleteFile:(id)sender {
    BOAlertController *sureAlertView = [[BOAlertController alloc] initWithTitle:@"提示" message:@"您确定删除该文件吗？" subView:nil viewController:self];
    
    RIButtonItem *okItem = [RIButtonItem itemWithLabel:@"确定" action:^(){
        [self submitDeleteFile];    
    }];
    [sureAlertView addButton:okItem type:RIButtonItemType_Other];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^(){}];
    [sureAlertView addButton:cancelItem type:RIButtonItemType_Other];
    
    [sureAlertView show];
}

- (void)submitDeleteFile {
    [self.view.window showHUDWithText:@"提交请求" Type:ShowLoading Enabled:YES];
    NSString *employeeId     = [userInfo gainUserId];
    NSString *realName       = [userInfo gainUserName];
    NSString *enterpriseId   = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"accessoryId": accessoryId};
    
    [self createAsynchronousRequest:DeleteAccessoryAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithTaskDetailInfoResult: dic];
    } failure:^{}];
}

//处理网络操作结果
- (void)dealWithTaskDetailInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"删除成功" Type:ShowPhotoYes Enabled:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteAccessaryFile" object:@"0"];
            [self performSelector:@selector(comeback) withObject:nil afterDelay:0.9];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeback {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 预览文件
- (IBAction)openFIleWithOterAPP:(id)sender {
    // Present Open In Menu
    [documentInteractionController presentOptionsMenuFromRect:[sender frame] inView:self.view animated:YES];
}


#pragma mark - Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}
@end
