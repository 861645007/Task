//
//  ModifyTaskTitleViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/21.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@protocol ModifyTaskContextInfoProtocol <NSObject>

- (void)modifyTaskContextInfo:(NSString *)taskContext;

@end

@interface ModifyTaskTitleViewController : BaseViewController

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *taskContent;
@property (nonatomic) id<ModifyTaskContextInfoProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITextView *taskContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskInstructionLabel;

- (IBAction)hiddenKeyboard:(id)sender;
@end
