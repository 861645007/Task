//
//  PreviewFileViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomToolClass.h"

@interface PreviewFileViewController : BaseViewController<UIDocumentInteractionControllerDelegate>

@property int isTaskOrReportAccessory;           // 0 获取表示任务附件； 1 表示获取汇报任务附件； 2 表示Leave Accessary
@property int isReportOrJudgeAccessory;          // 0 获取表示汇报任务附件； 1 表示获取judge任务附件
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *accessoryId;

@property (weak, nonatomic) IBOutlet UIView *toolVIew;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadingProcessView;

- (IBAction)deleteFile:(id)sender;
- (IBAction)openFIleWithOterAPP:(id)sender;

@end
