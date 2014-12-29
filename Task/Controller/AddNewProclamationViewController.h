//
//  AddNewProclamationViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface AddNewProclamationViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *proclamationTextView;
@property (nonatomic, copy) NSString *noticeId;
@property (nonatomic, copy) NSString *proclamationContext;

- (IBAction)hiddenKeyboard:(id)sender;
@end
