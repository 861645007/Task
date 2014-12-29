//
//  ProclamationUsersInfoViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationUsersInfoViewController.h"

@interface ProclamationUsersInfoViewController ()

@end

@implementation ProclamationUsersInfoViewController
@synthesize proclamationUsersInfoArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [proclamationUsersInfoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProclamationUsersInfoCell";
    ProclamationUsersInfoTableViewCell *cell = (ProclamationUsersInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dic = [proclamationUsersInfoArr objectAtIndex:indexPath.row];
    
    cell.proclamationUsersInfoContextLabel.text = [dic objectForKey:@"check"];
    cell.proclamationUsersInfoNameLabel.text = [dic objectForKey:@"realName"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
