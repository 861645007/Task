//
//  TaskOtherDetailInfoTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/20.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskOtherDetailInfoTableViewCell.h"

@implementation TaskOtherDetailInfoTableViewCell
@synthesize otherDetailInfoLabel;
@synthesize otherDetailInfoTitleLabel;
@synthesize actionBlock;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 向 Cell 中加入 View
- (void)addNewView:(NSArray *)dataArr dictionaryKey:(NSString *)keyStr lastText:(NSString *)lastTextStr {
    
    // 清楚试图中的原有控件
    for (UIView *view in [self.contentView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    self.otherDetailInfoLabel.hidden = YES;
    
    int originX = 80;
    int originY = 0;
    int sizeW = self.contentView.frame.size.width - 88;
    int sizeH = 43;

    int i = 0;
    for (NSDictionary *dic in dataArr) {
        // 添加 btn；
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
        button.titleLabel.textAlignment   = NSTextAlignmentLeft;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
        button.tag                        = i;
        
        [button setTitle:[dic objectForKey:keyStr] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        originY += sizeH;
        
        // 添加底线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, sizeW, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0f]];
        [self.contentView addSubview:lineView];
        originY += 1;
        
        i++;
    }
   
    
    UIButton *cusButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
    cusButton.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
    cusButton.titleLabel.textAlignment   = NSTextAlignmentLeft;
    cusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cusButton setTitle:lastTextStr forState:UIControlStateNormal];
    [cusButton setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f] forState:UIControlStateNormal];
    cusButton.tag = i;
    [self.contentView addSubview:cusButton];
}


- (void)addButtonAndLabel:(NSString *)keyStr withIndex:(int)index {
    int originX = 80;
    int originY = 44 * index ;
    int sizeW = self.contentView.frame.size.width - 88;
    int sizeH = 43;
    
    // 添加 btn；
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
    button.titleLabel.textAlignment   = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
    
    [button setTitle:keyStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    originY += sizeH;
    
    // 添加底线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, sizeW, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0f]];
    [self.contentView addSubview:lineView];
}

- (void)addLastBtn:(NSString *)keyStr withIndex:(int)index {
   
    int originX = 80;
    int originY = 44 * index ;
    int sizeW = self.contentView.frame.size.width - 88;
    int sizeH = 43;
    // 添加 btn；
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
    button.titleLabel.textAlignment   = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
    
    [button setTitle:keyStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(achieveBlock) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)achieveBlock {
    if (actionBlock == nil) {
        NSLog(@"222");
    }
    actionBlock();
}















@end
