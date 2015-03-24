//
//  PingjiaViewController.h
//  Task
//
//  Created by JackXu on 15/3/23.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PingjiaViewController :BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong)NSString *taskId;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
