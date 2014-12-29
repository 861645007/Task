//
//  ModifyUrgentLevelViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/22.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ModifyUrgentLevelViewController.h"

@interface ModifyUrgentLevelViewController () {
    NSArray *imageArr;
    NSArray *titleArr;
}

@end

@implementation ModifyUrgentLevelViewController
@synthesize delegate;
@synthesize urgentStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageArr = @[@"Nomal", @"Urgent", @"Very_urgent"];
    titleArr = @[@"普通", @"紧急", @"非常紧急"];
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

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imageArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UrgentLevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    
    if ([urgentStr intValue] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(selectedUrgentLevel:)]) {
        [self.delegate selectedUrgentLevel:[NSString stringWithFormat:@"%d", indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
