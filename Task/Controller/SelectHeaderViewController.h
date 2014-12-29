//
//  SelectHeaderViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectHeaderTableViewCell.h"
#import "ChineseString.h"

@protocol SelectedHeaderProtocol <NSObject>

- (void)selectedHeader:(NSArray *)headerList;

@end

@interface SelectHeaderViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<SelectedHeaderProtocol> delegate;
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic) int isRadio; // 0: 单选  1: 多选
@property (weak, nonatomic) IBOutlet UILabel *selectedHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *selectedAllItemBtn;

- (IBAction)selectedAllItem:(id)sender;

@end
