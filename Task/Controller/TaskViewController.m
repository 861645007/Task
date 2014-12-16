//
//  TaskViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController (){
    CusNavigationTitleView *navView;
    NSArray *navArr;
}

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navArr = @[@"item1", @"选项2", @"选项3"];
    
    navView = [[CusNavigationTitleView alloc] initWithTitle:@"我的任务" imageName:nil];
    [navView.titleBtn addTarget:self action:@selector(selectItemNav:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = navView;
}

- (void)selectItemNav:(UIButton *)sender {
    CGPoint point = CGPointMake((self.view.frame.size.width - 30) / 2, sender.frame.origin.y + sender.frame.size.height);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:navArr images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        navView.titleString = navArr[(long)index];
    };
    [pop show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Menu操作
- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}
@end
