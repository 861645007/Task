//
//  SelectHeaderTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectedHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectedHeaderNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIsImageView;


@end
