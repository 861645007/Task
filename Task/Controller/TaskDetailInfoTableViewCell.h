//
//  TaskDetailInfoTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/20.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCreaterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLabel;

@end
