//
//  TaskOtherDetailInfoTableViewCell.h
//  Task
//
//  Created by wanghuanqiang on 14/12/20.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskOtherDetailInfoTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^actionBlock)();

@property (weak, nonatomic) IBOutlet UILabel *otherDetailInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDetailInfoLabel;

- (void)addNewView:(NSArray *)dataArr dictionaryKey:(NSString *)keyStr lastText:(NSString *)lastTextStr;

- (void)addButtonAndLabel:(NSString *)keyStr withIndex:(int)index;
- (void)addLastBtn:(NSString *)keyStr withIndex:(int)index;
@end
