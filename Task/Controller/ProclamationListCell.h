//
//  ProclamationListCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProclamationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *proclamationContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *proclamationCreaterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *proclamationCreaterTimeLabel;


@end
