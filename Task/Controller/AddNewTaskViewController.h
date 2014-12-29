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

@interface AddNewTaskViewController : BaseViewController<UITextFieldDelegate, SelectedHeaderProtocol>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskLeaderBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskEndTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveWithContinueAddNewTaskBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveWithPerfectTaskInfoBtn;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *taskEndTimeStr;

- (IBAction)selectTaskLeader:(id)sender;
- (IBAction)selectTaskEndTime:(id)sender;
- (IBAction)saveWithContinueAddNewTask:(id)sender;
- (IBAction)saveWithPerfectTaskInfo:(id)sender;
- (IBAction)hiddenKeyBoard:(id)sender;

@end
