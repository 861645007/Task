//
//  TaskReportTableViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/27.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskReportTableViewCell.h"
#import "PlistOperation.h"

@implementation TaskReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAutoHeight:(NSArray *)reportContentArr reportAccessorysList:(NSArray *)reportAccessorysArr baseViewController:(UIViewController *)viewController {
    reportAccessorysList = [NSArray arrayWithArray:reportAccessorysArr];
    baseViewController = viewController;
    
    int originX = 46;
    int originY = 60;
    int sizeW = [[UIScreen mainScreen] bounds].size.width - 62;
    
    // 获取字符串
    NSString *contentText = [NSString stringWithFormat:@""];
    for (NSDictionary *reportContentDic in reportContentArr) {
        if ([reportContentDic isEqual:[reportContentArr lastObject]]) {
            contentText = [contentText stringByAppendingFormat:@"@%@ %@", [reportContentDic objectForKey:@"judgedUserName"], [reportContentDic objectForKey:@"judgeContent"]];
        }else {
            contentText = [contentText stringByAppendingFormat:@"@%@ %@ \n", [reportContentDic objectForKey:@"judgedUserName"], [reportContentDic objectForKey:@"judgeContent"]];
        }
    }
    
    // 获取内容高度
    CGFloat contentH = [self textHeight:contentText];
    UILabel *judgeContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, sizeW, contentH)];
    [judgeContentLabel setText:contentText];
    judgeContentLabel.numberOfLines = 0;
    judgeContentLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:judgeContentLabel];
    
    // 设置附件
    CGFloat accessoryOriginY = originY + contentH + 4;
    for (int i = 0; i < [reportAccessorysArr count]; i++) {
        NSDictionary *accessoryDic = [reportAccessorysArr objectAtIndex:i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, accessoryOriginY, sizeW, 30)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitle:[accessoryDic objectForKey:@"accessoryName"] forState:UIControlStateNormal];
        [btn setTitleColor:GrayColorForTitle forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn addTarget:self action:@selector(gainToPreview:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        accessoryOriginY += 30;
        
        if (i != [reportAccessorysArr count] - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX, accessoryOriginY, sizeW + 8, 1)];
            [line  setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0f]];
            [self.contentView addSubview:line];
        }
    }

    if ([reportAccessorysArr count] != 0) {
        UILabel *accessoryTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, originY + contentH + 4, sizeW, 30)];
        [accessoryTitlelabel setText:@"附件:"];
        accessoryTitlelabel.numberOfLines = 0;
        accessoryTitlelabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:accessoryTitlelabel];
    }
    
    [self.contentView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, accessoryOriginY + 27)];
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

- (void)gainToPreview:(UIButton *)btn {
    NSDictionary *dic = [reportAccessorysList objectAtIndex:btn.tag];
    
    PreviewFileViewController *previewFileViewController = [baseViewController.storyboard instantiateViewControllerWithIdentifier:@"PreviewFileViewController"];
    previewFileViewController.isTaskOrReportAccessory = 1;
    previewFileViewController.accessoryId = [dic objectForKey:@"accessoryId"];
    previewFileViewController.fileName = [dic objectForKey:@"accessoryTempName"];
    [baseViewController.navigationController pushViewController:previewFileViewController animated:YES];
}

@end
