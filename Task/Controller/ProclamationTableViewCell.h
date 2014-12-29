//
//  ProclamationTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolClass.h"

@interface ProclamationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *proclamationView;
@property (weak, nonatomic) IBOutlet UILabel *proclamationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *proclamationUnreadNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskAddImageView;
@property (weak, nonatomic) IBOutlet UIButton *gainToUnReadViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *gainToCurrenProclamationViewBtn;

@end
