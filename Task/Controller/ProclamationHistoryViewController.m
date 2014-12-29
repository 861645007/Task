//
//  ProclamationHistoryViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationHistoryViewController.h"

@interface ProclamationHistoryViewController () {
    
}

@end

@implementation ProclamationHistoryViewController
@synthesize proclamationList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [proclamationList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdertifier = @"ProclamationHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdertifier];
    
    NSDictionary *dic = [proclamationList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"content"];
    cell.detailTextLabel.text = [dic objectForKey:@"realName"];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *dic = [proclamationList objectAtIndex:indexPath.row];
    
    ProclamationDetailInfoViewController *proclamationDetailInfoViewController = [segue destinationViewController];
    proclamationDetailInfoViewController.noticeId = [dic objectForKey:@"noticeId"];
}


@end
