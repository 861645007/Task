//
//  GonggaoTableViewCell.h
//  Task
//
//  Created by JackXu on 15/3/24.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GonggaoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UIImageView *isNew;

@property (weak, nonatomic) IBOutlet UILabel *date;


@end
