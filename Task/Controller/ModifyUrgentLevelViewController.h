//
//  ModifyUrgentLevelViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/22.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectedUrgentLevelProtocol <NSObject>

- (void)selectedUrgentLevel:(NSString *)urgentLevel;

@end

@interface ModifyUrgentLevelViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) id<SelectedUrgentLevelProtocol> delegate;
@property (nonatomic, strong) NSString *urgentStr;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
