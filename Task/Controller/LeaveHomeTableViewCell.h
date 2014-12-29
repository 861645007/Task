//
//  LeaveHomeTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leaveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;

@end
