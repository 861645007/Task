//
//  CusTabBarViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/14.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "CusTabBarViewController.h"

@interface CusTabBarViewController ()

@end

@implementation CusTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为tabBar设置系统自带的标志，在UITabBarSystemItem中选择，并设置标签
    self.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:111];
    //为tabBar设置自定义的名称与图片，图片可以为空
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Second" image:nil tag:112];
    //设置小角标，一般为显示信息数量
    self.tabBarItem.badgeValue = @"1";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
