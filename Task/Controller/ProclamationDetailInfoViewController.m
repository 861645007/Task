//
//  ProclamationDetailInfoViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ProclamationDetailInfoViewController.h"

@interface ProclamationDetailInfoViewController () {
    NSArray *cellTitleArr;
    NSDictionary *cellTitleWithKey;
    NSMutableDictionary *cellInfoDic;
    NSMutableDictionary *proclamationInfoDic;
    
    NSString *proclamationId;
    NSMutableArray *proclamationCommentList;
    NSMutableArray *proclamationUserInfoList;
}

@end

@implementation ProclamationDetailInfoViewController
@synthesize mainTableView;
@synthesize noticeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    proclamationCommentList = [NSMutableArray array];
    cellInfoDic = [NSMutableDictionary dictionary];
    proclamationInfoDic = [NSMutableDictionary dictionary];
    proclamationUserInfoList = [NSMutableArray array];
    cellTitleArr = @[@"公告内容", @"创建人", @"创建时间", @"公告查看次数", @"公告用户数"];
    cellTitleWithKey = @{@"公告内容":@"content",
                         @"创建人":@"realName",
                         @"创建时间":@"createTime",
                         @"公告查看次数":@"checkCount",
                         @"公告用户数":@"noticeUsers"};
    
    // 编辑公告
    UIBarButtonItem *editProclamationBar = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editProclamation)];

    self.navigationItem.rightBarButtonItem = editProclamationBar;
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainProclamationDetailInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gainProclamationDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 编辑公告 proclamation
- (void)editProclamation {
    AddNewProclamationViewController *addNewProclamationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewProclamationViewController"];
    addNewProclamationViewController.proclamationContext = [proclamationInfoDic objectForKey:@"content"];
    addNewProclamationViewController.noticeId = [proclamationInfoDic objectForKey:@"noticeId"];
    [self.navigationController pushViewController:addNewProclamationViewController animated:YES];
}

#pragma mark - 获取公告信息
- (void)gainProclamationDetailInfo {
    [self.view.window showHUDWithText:@"加载数据" Type:ShowLoading Enabled:YES];
    
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"noticeId": noticeId};
    
    [self createAsynchronousRequest:NoticeDetailAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainProclamationInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }];
}

//处理网络操作结果
- (void)dealWithGainProclamationInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取信息成功" Type:ShowPhotoYes Enabled:YES];
            if (![[dic objectForKey:@"noticeList"] isEqualToArray:@[]]) {
                proclamationInfoDic = [dic objectForKey:@"noticeInfo"];
                
                [self setProclamationInfo:[dic objectForKey:@"noticeInfo"]];
                proclamationId = [[dic objectForKey:@"noticeInfo"] objectForKey:@"noticeId"];
                
                proclamationUserInfoList = [dic objectForKey:@"noticeUsers"];
                [cellInfoDic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[[dic objectForKey:@"noticeUsers"] count]] forKey:@"公告用户数"];
                proclamationCommentList = [dic objectForKey:@"comments"];
                
                [mainTableView reloadData];
            }
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)setProclamationInfo:(NSDictionary *)dic {
    for (NSString *key in cellTitleArr) {
        NSString *keyStr = [cellTitleWithKey objectForKey:key];
        for (NSString *keyNotice in [dic allKeys]) {
            if ([keyStr isEqualToString:keyNotice]) {
                
                [cellInfoDic setObject:[NSString stringWithFormat:@"%@", [dic objectForKey:keyStr]] forKey:key];
            }
        }
    }
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([cellInfoDic isEqual:@{}]) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([cellInfoDic isEqual:@{}]) {
            return 0;
        }
        return [cellTitleArr count];
    }else {
        if ([proclamationCommentList isEqual:@[]]) {
            return 0;
        }
        return [proclamationCommentList count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *key = [cellTitleArr objectAtIndex:indexPath.row];
            return [self textHeight:[cellInfoDic objectForKey:key]] + 24;
        }
        return 44;
    }
    return  60;
}

// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //  ios7 的API，判断 labelText 这个字符串需要的高度；    这里的宽度（self.view.frame.size.width - 140he）按照需要自己换就 OK
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 62, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if ([labelText isEqualToString:@""]) {
        return 0;
    }
    return sizeText.height;
}


// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44)];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 1)];
        [lineView1 setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f]];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(16, 43, self.view.frame.size.width, 1)];
        [lineView2 setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f]];
        
        // 设置 section 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 320, 44)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"公告评论";
        [titleLabel sizeToFit];
        
        // 设置图标
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 9, 25, 25)];
        imageView.tag = 201;
        imageView.userInteractionEnabled = true;
        imageView.image = [UIImage imageNamed:@"Task_Add"];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewProclamationCommext)];
        [imageView addGestureRecognizer:tapGestureRecognizer];

        [sectionView addSubview:lineView1];
        [sectionView addSubview:lineView2];
        [sectionView addSubview:titleLabel];
        [sectionView addSubview:imageView];
        return sectionView;
    }
    return nil;
}

- (void)addNewProclamationCommext {
    ProclamationCommentsViewController *proclamationCommentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProclamationCommentsViewController"];
    proclamationCommentsViewController.noticeId = proclamationId;
    [self.navigationController pushViewController:proclamationCommentsViewController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"ProclamationDetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *key = [cellTitleArr objectAtIndex:indexPath.row];
        
        cell.textLabel.text = key;
        cell.detailTextLabel.text = [cellInfoDic objectForKey:key];
        
        if ([key isEqualToString:@"公告用户数"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }else {
        static NSString *cellIdentifier = @"ProclamationCommentCell";
        ProclamationListCell *cell = (ProclamationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSDictionary *dic = [proclamationCommentList objectAtIndex:indexPath.row];
        
        cell.proclamationContentLabel.text = [dic objectForKey:@"content"];
        cell.proclamationCreaterNameLabel.text = [dic objectForKey:@"realName"];
        cell.proclamationCreaterTimeLabel.text = [dic objectForKey:@"time"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [cellTitleArr objectAtIndex:indexPath.row];
    
    if ([key isEqualToString:@"公告用户数"]) {
        ProclamationUsersInfoViewController *proclamationUsersInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProclamationUsersInfoViewController"];
        proclamationUsersInfoViewController.proclamationUsersInfoArr = proclamationUserInfoList;
        [self.navigationController pushViewController:proclamationUsersInfoViewController animated:YES];
    }
}

@end
