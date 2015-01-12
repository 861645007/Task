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
    proclamationView.layer.borderWidth = 1;
    proclamationView.layer.masksToBounds = YES;
    proclamationView.layer.cornerRadius = 8.0;
    proclamationView.layer.borderColor = [UIColor colorWithRed:12/255.0 green:112/255.0 blue:186/255.0 alpha:1].CGColor;
    proclamationView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
