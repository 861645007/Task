//
//  EditLeaveViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectHeaderViewController.h"

@interface EditLeaveViewController : BaseViewController<SelectedHeaderProtocol>

@property (nonatomic) int isAddNewLeave;         // 0：新增请假     1：编辑请假

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *leaveId;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *leaveContent;
@property (nonatomic, copy) NSString *leaveStartTime;
@property (nonatomic, copy) NSString *leaveEndTime;
@property (nonatomic, copy) NSString *leaveApproveIds;
@property (nonatomic, copy) NSString *leaveApproveNames;

@property (weak, nonatomic) IBOutlet UIButton *sickLeaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *affairLeaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherLaeveBtn;
@property (weak, nonatomic) IBOutlet UITextView *leaveReasonTextView;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *gainApprovePersonBtn;


- (IBAction)hidenKeyboard:(id)sender;
- (IBAction)selectSickLeave:(id)sender;
- (IBAction)selectAffairLeave:(id)sender;
- (IBAction)selectOtherLeave:(id)sender;
- (IBAction)selectStartTime:(id)sender;
- (IBAction)selectEndTIme:(id)sender;
- (IBAction)gainApprovePerson:(id)sender;
- (IBAction)saveLeaveInfo:(id)sender;

@end
