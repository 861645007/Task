//
//  CusNavigationTitleView.h
//  NavigationTest
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//
/*    使用方法
 navView = [[CusNavigationTitleView alloc] initWithTitle:@"我的" imageName:nil];
 [navView.titleBtn addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
 
 self.navigationItem.titleView = navView;
 
 -(void)button2Clicked:(UIButton *)sender {
 CGPoint point = CGPointMake((self.view.frame.size.width - 40) / 2, sender.frame.origin.y + sender.frame.size.height);
 NSArray *titles = @[@"item1", @"选项2", @"选ee33434项3"];
 PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
 pop.selectRowAtIndex = ^(NSInteger index){
 NSLog(@"select index:%ld", (long)index);
 navView.titleString = titles[(long)index];
 };
 [pop show];
 }
 */

#import <UIKit/UIKit.h>
#import "PopoverView.h"

@interface CusNavigationTitleView : UIView

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageNameString;
@property (nonatomic, copy) NSArray *titleStrArr;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *titleImageView;

- (id)initWithTitle:(NSString *)titleStr titleStrArr:(NSArray *)titleArr imageName:(NSString *)imageNameStr;

@end
