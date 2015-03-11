//
//  AddNewTaskViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "Color.h"
#import "SelectHeaderViewController.h"
#import "TaskDetailInfoTableViewController.h"
#import "ModifyUrgentLevelViewController.h"

@interface AddNewTaskViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate, SelectedHeaderProtocol, SelectedUrgentLevelProtocol>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskLeaderBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskEndTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveWithPerfectTaskInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *selecteTaskJoinetBtn;
@property (weak, nonatomic) IBOutlet UITextView *taskCommentTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskCommentPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskTypeBtn;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *taskEndTimeStr;
@property (nonatomic, copy) NSString *superTaskId;

- (IBAction)selectTaskLeader:(id)sender;
- (IBAction)selectTaskEndTime:(id)sender;
- (IBAction)saveWithPerfectTaskInfo:(id)sender;
- (IBAction)hiddenKeyBoard:(id)sender;
- (IBAction)selectTaskType:(id)sender;

@end
