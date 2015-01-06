//
//  AddTaskReportJudgementViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "AddTaskReportJudgementCollectionViewCell.h"
#import "GetAllPhotoCollectionViewController.h"

@interface AddTaskReportJudgementViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate, SelectedPhotoProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) int isFeedBackOrJudgement;          // 0：表示反馈  1：表示评论
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *taskId;           // 反馈时使用的

@property (nonatomic, strong) NSString *judgeId;          // 评论 Id
@property (nonatomic, strong) NSString *taskReportId;     // 被评论的返回 Id
@property (nonatomic, strong) NSString *judgedUserId;     // 评论时的被评论人 Id
@property (nonatomic, strong) NSString *judgedUserName;   // 评论时的被评论人 Name
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;


@property (weak, nonatomic) IBOutlet UITextView *reportJudgementTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

- (IBAction)getImageWithCamera:(id)sender;
- (IBAction)getImageWithAlbum:(id)sender;
- (IBAction)hiddenKeyboard:(id)sender;
@end
