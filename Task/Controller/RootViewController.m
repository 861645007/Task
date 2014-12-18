//
//  RootViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "RootViewController.h"
#import "UserInfo.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    if ([[UserInfo shareInstance] isCookie]) {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    }else {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    }
    
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
}

@end
