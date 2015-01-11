//
//  LeaveApprovesTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LeaveApprovesTableViewCell.h"

@implementation LeaveApprovesTableViewCell
@synthesize leaveApprovesTimeLabel;
@synthesize leaveApprovesNameLabel;
@synthesize leaveApprovesResultLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)gainLeaveApprovesCellHeight:(NSDictionary *)approvesDic {
    NSString *approvesReslut = @"";
    
    NSString *isApprove = [approvesDic objectForKey:@"isApprove"];
    
    if ([isApprove intValue] == 0) {
        approvesReslut = @"未审批";
    }else {
        NSString *result = [approvesDic objectForKey:@"result"];
        NSString *description = [self textIsNull:[approvesDic objectForKey:@"description"]];
        NSString *deliverName = [self textIsNull:[approvesDic objectForKey:@"deliverName"]];
        if ([result intValue]) {
            approvesReslut = [NSString stringWithFormat:@"请假已经被同意"];
        }else {
            approvesReslut = [NSString stringWithFormat:@"请假没有被同意"];
        }
        
        if (![description isEqualToString:@""]) {
            approvesReslut = [approvesReslut stringByAppendingFormat:@"\n%@", description];
        }
        
        if (![deliverName isEqualToString:@""]) {
            approvesReslut = [approvesReslut stringByAppendingFormat:@"\n请假已经被移交至 %@ 处", deliverName];
        }
    }
    
    return [self textHeight:approvesReslut] + 40;
}


- (void)setLeaveApprovesResult:(NSDictionary *)approvesDic {
    NSString *approvesReslut = @"";
    
    NSString *isApprove = [approvesDic objectForKey:@"isApprove"];
    
    if ([isApprove intValue] == 0) {
        approvesReslut = @"未审批";
        leaveApprovesTimeLabel.hidden = YES;
    }else {
        NSString *result = [approvesDic objectForKey:@"result"];
        NSString *description = [self textIsNull:[approvesDic objectForKey:@"description"]];
        NSString *deliverName = [self textIsNull:[approvesDic objectForKey:@"deliverName"]];
        NSString *approvesTime = [self textIsNull:[approvesDic objectForKey:@"approveTime"]];
        if ([result intValue]) {
            approvesReslut = [NSString stringWithFormat:@"请假已经被同意"];
        }else {
            approvesReslut = [NSString stringWithFormat:@"请假没有被同意"];
        }
        
        if (![description isEqualToString:@""]) {
            approvesReslut = [approvesReslut stringByAppendingFormat:@"\n理由：%@", description];
        }
        
        if (![deliverName isEqualToString:@""]) {
            approvesReslut = [approvesReslut stringByAppendingFormat:@"\n请假已经被移交至 %@ 处", deliverName];
        }
        
        if (![approvesTime isEqualToString:@""]) {
            [leaveApprovesTimeLabel setText:approvesTime];
        }
    }
    [leaveApprovesResultLabel setFrame:CGRectMake(8, 32, [[UIScreen mainScreen] bounds].size.width - 16, [self textHeight:approvesReslut])];
    [leaveApprovesResultLabel setText:approvesReslut];
    [self.contentView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [self textHeight:approvesReslut] + 40)];
}

- (NSString *)textIsNull:(id)text {
    if (text == [NSNull null]) {
        return @"";
    }
    return text;
}

// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:13.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //  ios7 的API，判断 labelText 这个字符串需要的高度；    这里的宽度（self.view.frame.size.width - 140he）按照需要自己换就 OK
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if ([labelText isEqualToString:@""]) {
        return 0;
    }
    return sizeText.height;
}

@end


