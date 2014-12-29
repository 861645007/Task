//
//  ProclamationTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/18.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationTableViewCell.h"

@implementation ProclamationTableViewCell
@synthesize proclamationView;

- (void)awakeFromNib {
    // Initialization code
    proclamationView.layer.borderWidth = 0.5;
    proclamationView.layer.borderColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
