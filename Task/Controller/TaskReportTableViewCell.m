//
//  TaskReportTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/27.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskReportTableViewCell.h"

@implementation TaskReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAutoHeight:(NSArray *)reportContentArr reportAccessorysList:(NSArray *)reportAccessorysArr {
    int originX = 46;
    int originY = 60;
    int sizeW = [[UIScreen mainScreen] bounds].size.width - 62;
    
    // 获取字符串
    NSString *contentText = [NSString stringWithFormat:@""];
    for (NSDictionary *reportContentDic in reportContentArr) {
        contentText = [contentText stringByAppendingFormat:@"@%@ %@ \n", [reportContentDic objectForKey:@"judgedUserName"], [reportContentDic objectForKey:@"judgeContent"]];
    }
    
    NSString *accessoryText = [NSString string];
    for (NSDictionary *accessoryDic in reportAccessorysArr) {
        accessoryText = [accessoryText stringByAppendingFormat:@" %@ \n", [accessoryDic objectForKey:@"accessoryName"]];
    }
    
    // 获取并设置高度
    CGFloat contentH = [self textHeight:contentText];
    CGFloat accessoryH = [self textHeight:accessoryText];
    
    UILabel *judgeContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, sizeW, contentH)];
    [judgeContentLabel setText:contentText];
    judgeContentLabel.numberOfLines = 0;
    judgeContentLabel.font = [UIFont systemFontOfSize:13];
    
    UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY + contentH + 8, sizeW, accessoryH)];
    [accessoryLabel setText:accessoryText];
    accessoryLabel.numberOfLines = 0;
    accessoryLabel.font = [UIFont systemFontOfSize:13];
    
    UILabel *accessoryTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, originY + contentH + 8, sizeW, 19)];
    [accessoryTitlelabel setText:@"附件:"];
    accessoryTitlelabel.numberOfLines = 0;
    accessoryTitlelabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:judgeContentLabel];
    [self.contentView addSubview:accessoryLabel];
    
    if (accessoryH != 0) {
        [self.contentView addSubview:accessoryTitlelabel];
    }

    [self.contentView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60 + contentH + accessoryH + 27)];
}


// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:13.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //  ios7 的API，判断 labelText 这个字符串需要的高度；    这里的宽度（self.view.frame.size.width - 140he）按照需要自己换就 OK
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 62, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if ([labelText isEqualToString:@""]) {
        return 0;
    }
    return sizeText.height;
}

@end
