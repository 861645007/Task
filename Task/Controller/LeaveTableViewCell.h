//
//  LeaveTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 15/1/13.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leavePersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;
@end
