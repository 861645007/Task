//
//  LeaveApprovesTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveApprovesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leaveApprovesNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveApprovesTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveApprovesResultLabel;

- (CGFloat)gainLeaveApprovesCellHeight:(NSDictionary *)approvesDic;
- (void)setLeaveApprovesResult:(NSDictionary *)approvesDic;
@end
