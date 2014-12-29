//
//  TaskReportTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/27.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *reportPersonIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *reportPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportTransferBtn;
@property (weak, nonatomic) IBOutlet UIButton *reportReplyBtn;

- (void)setAutoHeight:(NSArray *)reportContentArr reportAccessorysList:(NSArray *)reportAccessorysArr;

@end
