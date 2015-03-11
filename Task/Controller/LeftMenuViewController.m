//
//  LeftMenuViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "PlistOperation.h"

@interface LeftMenuViewController () {
    NSString *personPhone;
    NSString *personEmail;
    NSString *personDepartment;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end

@implementation LeftMenuViewController
@synthesize mainTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainTableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.opaque = NO;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [self gainHeaderImageImage];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = [userInfo gainUserName];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    
    [self setTableFooterView:self.mainTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    personDepartment = [userInfo gainUserDepartment];
    personEmail = [userInfo gainUserEmail];
    personPhone = [userInfo gainUserPhone];
    
    if ([personPhone isEqualToString:@""]) {
        [self createSimpleAlertView:@"baoq" msg:@"请先前往“更多 -> 个人资料”中获取个人信息"];
    }
    [self.mainTableView reloadData];
}

- (UIImage *)gainHeaderImageImage {
    NSArray *array = [[PlistOperation shareInstance] gainAllPersonInfoWithFile];
    NSString *userId = [userInfo gainUserId];
    NSString *userImageName = @"";
    
    for (NSDictionary *dic in array) {
        NSString *employeeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"employeeId"]];
        if ([userId isEqual:employeeId]) {
            userImageName = [dic objectForKey:@"image"];
            break;
        }
    }
    
    UIImage *img = [[PlistOperation shareInstance] gainPersonImage:userImageName];
    return img;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;

    
//    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[[NSString stringWithFormat:@"手机号： %@", personPhone],
                            [NSString stringWithFormat:@"Email：  %@", personEmail],
                            [NSString stringWithFormat:@"部门：    %@", personDepartment]];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - back



@end
