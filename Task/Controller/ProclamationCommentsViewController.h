//
//  ProclamationCommentsViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@interface ProclamationCommentsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, copy) NSString* noticeId;

- (IBAction)hiddenKeboard:(id)sender;

@end
