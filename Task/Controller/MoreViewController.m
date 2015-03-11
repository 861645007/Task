//
//  MoreViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/17.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "MoreViewController.h"
#import "PersonInfoViewController.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"
#import "AutoUpdateVersion.h"

@interface MoreViewController () {
    NSArray *tableViewData;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableViewData = @[@[@"个人资料"], @[@"新版本检查", @"关于"]];
    [self setTableFooterView:self.mainTableView];
    self.mainTableView.tableFooterView = [self gainFootView];
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)gainFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    footView.backgroundColor = self.mainTableView.backgroundColor;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 7, 200, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:btn];
    
    return footView;
}

- (void)logOut {
    [self gotoLogInController];
}

//转到主界面
- (void)gotoLogInController {
    //视图转换 至 rootViewController  （原理：直接将根视图转换----只能在主线程生调用）
    REFrostedViewController *frosted = [[REFrostedViewController alloc] initWithContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"] menuViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"]];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = frosted;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView DataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableViewData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 26;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 19)];
        titleLabel.textColor = GrayColorForTitle;
        titleLabel.text = @"   其他";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        return titleLabel;
    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = [[tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PersonInfoViewController *personInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
            [self.navigationController pushViewController:personInfoViewController animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self checkNewVersion];
        }else if (indexPath.row == 1) {
            [self gainToAboutUsView];
        }
    }
}

#pragma mark - 检查新版本
- (void)checkNewVersion {
    [[AutoUpdateVersion alloc] checkNewVersion:self isAutoSelected:0];
}

#pragma mark - 关于我们
- (void)gainToAboutUsView {
    AboutUsViewController *aboutUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

@end
