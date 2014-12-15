//
//  RootViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
}

@end
