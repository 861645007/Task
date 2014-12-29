//
//  ApprovesLeaveViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectHeaderViewController.h"

@interface ApprovesLeaveViewController : BaseViewController<SelectedHeaderProtocol>

@property (nonatomic, copy) NSString *leaveId;
@property (nonatomic, copy) NSString *leaveApproveId;

@property (weak, nonatomic) IBOutlet UIButton *agreeLeaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *disagreeLeaveBtn;
@property (weak, nonatomic) IBOutlet UITextView *approvesDescTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectedDeliverPersonBtn;


- (IBAction)selectedDeliverPerson:(id)sender;
- (IBAction)disagreeLeave:(id)sender;
- (IBAction)agreeLeave:(id)sender;

- (IBAction)approveLeave:(id)sender;
- (IBAction)hidenKeyboard:(id)sender;



@end
