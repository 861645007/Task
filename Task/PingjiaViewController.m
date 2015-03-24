//
//  PingjiaViewController.m
//  Task
//
//  Created by JackXu on 15/3/23.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "PingjiaViewController.h"

@interface PingjiaViewController (){
    NSArray *arry;
}

@end

@implementation PingjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arry = [[NSArray alloc] initWithObjects:
     @"满意",@"一般",@"不满意",nil];
    [self setTableFooterView:self.mainTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"[arry count]:%lu",(unsigned long)[arry count]);
       return [arry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingjiaCell"];
    cell.textLabel.text = [arry objectAtIndex:indexPath.row];
    NSString *imageName;
    switch (indexPath.row) {
        case 0:
            imageName = @"pingjiamanyi.png";
            break;
        case 1:
            imageName = @"pingjiayiban.png";
            break;
        case 2:
            imageName = @"bumanyi.png";
            break;
        default:
            break;
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;

}

-(void)dealWithResult:(NSDictionary*) dic{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *evaluation;
    switch (indexPath.row) {
        case 0:
            evaluation =  @"1";
            break;
        case 1:
            evaluation =  @"2";
            break;
        case 2:
            evaluation =  @"3";
            break;
            default:
            evaluation = @"0";break;
    }
    //参数
    NSString *employeeId     = [userInfo gainUserId];
    NSString *realName       = [userInfo gainUserName];
    NSString *enterpriseId   = [userInfo gainUserEnterpriseId];
    
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId": self.taskId,
                                 @"evaluation": evaluation
                                 };
    [self createAsynchronousRequest:addTaskEvaluationAction parmeters:parameters success:^(NSDictionary *dic){
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
    }];

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


