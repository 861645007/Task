//
//  TaskReportTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/27.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskReportTableViewCell.h"
#import "PlistOperation.h"
#import "AddTaskReportJudgementViewController.h"

@implementation TaskReportTableViewCell
@synthesize reportContentLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 设置cell高度和其内容控件
- (void)setAutoHeight:(NSDictionary *)taskReportDic taskId:(NSString *)taskId baseViewController:(UIViewController *)viewController {
    theTaskId = taskId;
    reportDic = [NSDictionary dictionaryWithDictionary:taskReportDic];
    NSString *taskContentText = [taskReportDic objectForKey:@"desc"];
    NSArray *reportAccessorysArr = [taskReportDic objectForKey:@"reportAccessorys"];
    NSArray *reportJudges = [taskReportDic objectForKey:@"reportJudges"];
    NSArray *reportContentArr = [taskReportDic objectForKey:@"reportJudges"];
    
    reportAccessorysList = [NSMutableArray array];
    
    for (NSDictionary *accessaryInfo in reportAccessorysArr) {
        NSMutableDictionary *accessaryInfoCopy = [NSMutableDictionary dictionaryWithDictionary:accessaryInfo];
        [accessaryInfoCopy setValue:@"0" forKey:@"isReportOrJudgeAccessory"];
        [reportAccessorysList addObject:accessaryInfoCopy];
    }
    
    for (NSDictionary *reportAccessaryInfo in reportJudges) {
        for (NSDictionary *accessaryInfo  in [reportAccessaryInfo objectForKey:@"judgeAccessorys"]) {
            NSMutableDictionary *accessaryInfoCopy = [NSMutableDictionary dictionaryWithDictionary:accessaryInfo];
            [accessaryInfoCopy setValue:@"1" forKey:@"isReportOrJudgeAccessory"];
            [reportAccessorysList addObject:accessaryInfoCopy];
        }
    }
    
    baseViewController = viewController;
    
    int originX = 50;
    int originY = 30 + [self textHeight:taskContentText];
    int sizeW = [[UIScreen mainScreen] bounds].size.width - 62;
    
    // 获取字符串
    CGFloat judgeOriginY = originY + 8;
    for (int i = 0; i < [reportContentArr count]; i++) {
        NSDictionary *judgeDic = [reportContentArr objectAtIndex:i];
        
        NSString *contentText = [NSString stringWithFormat:@"@%@ %@", [judgeDic objectForKey:@"judgedUserName"], [judgeDic objectForKey:@"judgeContent"]];
        
        UILabel *judgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, judgeOriginY, sizeW, [self textHeight:contentText] + 3)];
        judgeLabel.textAlignment = NSTextAlignmentLeft;
        judgeLabel.text = contentText;
        judgeLabel.font = [UIFont systemFontOfSize:14];
        judgeLabel.numberOfLines = 0;
        judgeLabel.tag = i;
        judgeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyTaskReportJudgement:)];
        [judgeLabel addGestureRecognizer:tapG];
        [self.contentView addSubview:judgeLabel];
        judgeOriginY += ([self textHeight:contentText] + 3);
    }
    
    
    // 设置附件
    CGFloat accessoryOriginY = judgeOriginY;
    for (int i = 0; i < [reportAccessorysList count]; i++) {
        NSDictionary *accessoryDic = [reportAccessorysList objectAtIndex:i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, accessoryOriginY, sizeW, 30)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitle:[accessoryDic objectForKey:@"accessoryName"] forState:UIControlStateNormal];
        [btn setTitleColor:GrayColorForTitle forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn addTarget:self action:@selector(gainToPreview:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        accessoryOriginY += 30;
        
        if (i != [reportAccessorysList count] - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX, accessoryOriginY, sizeW + 8, 1)];
            [line  setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0f]];
            [self.contentView addSubview:line];
        }
    }

    if ([reportAccessorysList count] != 0) {
        UILabel *accessoryTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, judgeOriginY, sizeW, 30)];
        [accessoryTitlelabel setText:@"附件:"];
        accessoryTitlelabel.numberOfLines = 0;
        accessoryTitlelabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:accessoryTitlelabel];
    }
    
    [self.contentView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, accessoryOriginY + 27)];
}


// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //  ios7 的API，判断 labelText 这个字符串需要的高度；    这里的宽度（self.view.frame.size.width - 140he）按照需要自己换就 OK
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 62, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if ([labelText isEqualToString:@""]) {
        return 0;
    }
    return sizeText.height;
}


// 获取个人照片
- (UIImage *)gainUserIcon:(NSString *)userId {
    NSString *imageName = @"";
    NSArray *personArr = [[PlistOperation shareInstance] gainAllPersonInfoWithFile];
    for (NSDictionary *dic in personArr) {
        if ([userId isEqual:[dic objectForKey:@"employeeId"]]) {
            imageName = [dic objectForKey:@"image"];
            break ;
        }
    }
    UIImage *image = [[PlistOperation shareInstance] gainPersonImage:imageName];
    return  image;
}


// 预览附件
- (void)gainToPreview:(UIButton *)btn {
    NSDictionary *dic = [reportAccessorysList objectAtIndex:btn.tag];
    
    PreviewFileViewController *previewFileViewController = [baseViewController.storyboard instantiateViewControllerWithIdentifier:@"PreviewFileViewController"];
    previewFileViewController.isTaskOrReportAccessory = 1;
    previewFileViewController.isReportOrJudgeAccessory = [[dic objectForKey:@"isReportOrJudgeAccessory"] intValue];
    previewFileViewController.accessoryId = [dic objectForKey:@"accessoryId"];
    previewFileViewController.fileName = [dic objectForKey:@"accessoryTempName"];
    [baseViewController.navigationController pushViewController:previewFileViewController animated:YES];
}

// 修改评论回复接口
- (void)modifyTaskReportJudgement:(UITapGestureRecognizer *)tapG {
    UILabel *label = (UILabel *)tapG.view;
    NSDictionary *judgeDic = [[reportDic objectForKey:@"reportJudges"] objectAtIndex:label.tag];
    
    AddTaskReportJudgementViewController *addTaskReportJudgementViewController = [baseViewController.storyboard instantiateViewControllerWithIdentifier:@"AddTaskReportJudgementViewController"];
    addTaskReportJudgementViewController.isFeedBackOrJudgement = 1;
    addTaskReportJudgementViewController.titleStr = @"修改评论";
    addTaskReportJudgementViewController.desc = [judgeDic objectForKey:@"judgeContent"];
    addTaskReportJudgementViewController.judgeId = [NSString stringWithFormat:@"%@",[judgeDic objectForKey:@"judgeId"]];
    addTaskReportJudgementViewController.taskReportId = [reportDic objectForKey:@"taskReportId"];
    addTaskReportJudgementViewController.judgedUserId = [reportDic objectForKey:@"reportPersonId"];
    addTaskReportJudgementViewController.judgedUserName = [reportDic objectForKey:@"reportPersonName"];
    addTaskReportJudgementViewController.taskId = theTaskId;
    [baseViewController.navigationController pushViewController:addTaskReportJudgementViewController animated:YES];
}


@end
