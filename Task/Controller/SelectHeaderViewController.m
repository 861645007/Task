//
//  SelectHeaderViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "SelectHeaderViewController.h"
#import "PlistOperation.h"

@interface SelectHeaderViewController () {
    NSArray *indexArr;
    NSMutableArray *titleSortArr;       // cell的 title 数组
    NSMutableDictionary *headerListDic;   // 包含了所有的数据
}

@end

@implementation SelectHeaderViewController
@synthesize selectedHeaderLabel;
@synthesize mainTableView;
@synthesize viewTitle;
@synthesize isRadio;
@synthesize delegate;
@synthesize selectedAllItemBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headerListDic = [NSMutableDictionary dictionary];
    titleSortArr = [NSMutableArray array];
    if (!isRadio) {
        selectedAllItemBtn.hidden = YES;
    }
    if (![viewTitle isEqualToString:@""]) {
        self.title = viewTitle;
    }
    
    // 确认按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(sureHeader)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainHeaderInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gainPersonInfoWithFolder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gainPersonInfoWithFolder {
    NSArray *array = [[PlistOperation shareInstance] gainAllPersonInfoWithFile];
    
    if ([array isEqualToArray:@[]] || array == nil) {
        [self gainHeaderInfo];
    }else {
        [self setIndexSection:array];
        [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [mainTableView reloadData];
    }
}

#pragma mark - 获取联系人信息
- (void)gainHeaderInfo {
    [self.view.window showHUDWithText:@"正在获取" Type:ShowLoading Enabled:YES];
    NSString *employeeId = [userInfo gainUserId];
    NSString *realName = [userInfo gainUserName];
    NSString *enterpriseId = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId};
    
    [self createAsynchronousRequest:AllEmployeesAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithGainProclamationInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
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
            
            if ([[dic objectForKey:@"employees"] isEqualToArray:@[]]) {
                [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            }else {
                [[PlistOperation shareInstance] saveAllPersonInfoToFile:[dic objectForKey:@"employees"]];
                [self performSelector:@selector(gainPersonInfoWithFolder) withObject:nil afterDelay:0.3];
                [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            }
            
            [mainTableView reloadData];
            // 事情做完了, 结束刷新动画~~~
            [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)setIndexSection:(NSArray *)arr {
    NSMutableArray *pArr = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        [pArr addObject:[dic objectForKey:@"realName"]];
    }
    
    indexArr = [NSArray arrayWithArray:[ChineseString IndexArray:pArr]];
    titleSortArr = [NSMutableArray arrayWithArray:[ChineseString LetterSortArray:pArr]];
    
    for (NSArray *headerArr in titleSortArr) {
        for (NSString *headerNameStr in headerArr) {
            for (NSDictionary *dic in arr) {
                if ([headerNameStr isEqualToString:[dic objectForKey:@"realName"]]) {
                    NSMutableDictionary *pDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [pDic setObject:@"0" forKey:@"isSelected"];
                    [headerListDic setObject:[pDic copy] forKey:headerNameStr];
                    break;
                }
            }
        }
    }
}


#pragma mark - TableView Delegate

// 设置索引

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [titleSortArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[titleSortArr objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [sectionView setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
    label.text = [NSString stringWithFormat:@"%@", [indexArr objectAtIndex:section]];
    label.font = [UIFont fontWithName:@"Arial" size:13];
    
    [sectionView addSubview:label];
    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SelectHeaderCell";
    SelectHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *headerNameStr = [[titleSortArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSDictionary *dic = [headerListDic objectForKey:headerNameStr];
    
    cell.selectedHeaderNameLabel.text = headerNameStr;
    
    // 添加用户图片
    cell.selectedHeaderImageView.image = [[PlistOperation shareInstance] gainPersonImage:[dic objectForKey:@"image"]];
    
    // 判断是否被选中
    if ([[dic objectForKey:@"isSelected"] intValue] == 0) {
        cell.selectedIsImageView.image = [UIImage imageNamed:@"Addchoice"];
    }else {
        cell.selectedIsImageView.image = [UIImage imageNamed:@"choose"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *headerNameStr = [[titleSortArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSMutableDictionary *headerdic = [NSMutableDictionary dictionaryWithDictionary:[headerListDic objectForKey:headerNameStr]];
    
    if (isRadio == 0) {
        // 单选
        if ([[headerdic objectForKey:@"isSelected"] intValue] == 0) {
            NSArray *keyArr = [headerListDic allKeys];
            for (int i = 0; i < [keyArr count]; i++) {
                NSString *key = keyArr[i];
                NSMutableDictionary *pDic = [NSMutableDictionary dictionaryWithDictionary:headerListDic[key]];
                [pDic setObject:@"0" forKey:@"isSelected"];
                [headerListDic setObject:[pDic copy] forKey:key];
            }
            
            headerdic[@"isSelected"] = @"1";
            [headerListDic setObject:headerdic forKey:headerNameStr];
            
            self.selectedHeaderLabel.text = [headerdic objectForKey:@"realName"];
            [tableView reloadData];
        }else {
            headerdic[@"isSelected"] = @"0";
            [headerListDic setObject:headerdic forKey:headerNameStr];
            
            self.selectedHeaderLabel.text = [self.selectedHeaderLabel.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[headerdic objectForKey:@"realName"]] withString:@""];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if (isRadio == 1) {
        if ([[headerdic objectForKey:@"isSelected"] intValue] == 0) {
            headerdic[@"isSelected"] = @"1";
            [headerListDic setObject:headerdic forKey:headerNameStr];
            
            self.selectedHeaderLabel.text = [self.selectedHeaderLabel.text stringByAppendingFormat:@"%@、", [headerdic objectForKey:@"realName"]];
            
        }else {
            headerdic[@"isSelected"] = @"0";
            [headerListDic setObject:headerdic forKey:headerNameStr];
            
            self.selectedHeaderLabel.text = [self.selectedHeaderLabel.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@、",[headerdic objectForKey:@"realName"]] withString:@""];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 确认负责人 
- (void)sureHeader {
    NSMutableArray *headerList = [NSMutableArray array];
    NSArray *headerKeyList = [self.selectedHeaderLabel.text componentsSeparatedByString:@"、"];
    for (NSString *key in headerKeyList) {
        if (![key isEqualToString:@""]) {
            [headerList addObject:[headerListDic objectForKey:key]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedHeader:)]) {
        [self.delegate selectedHeader:headerList];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  全选
- (IBAction)selectedAllItem:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    NSArray *keyArr = [headerListDic allKeys];
    
    if (btn.tag) {
        btn.tag = 0;
        [btn setImage:[UIImage imageNamed:@"Addchoice"] forState:UIControlStateNormal];
        for (int i = 0; i < [keyArr count]; i++) {
            NSString *key = keyArr[i];
            NSMutableDictionary *pDic = [NSMutableDictionary dictionaryWithDictionary:headerListDic[key]];
            [pDic setObject:@"0" forKey:@"isSelected"];
            [headerListDic setObject:[pDic copy] forKey:key];
        }
        self.selectedHeaderLabel.text = @"";
    }else {
        btn.tag = 1;
        [btn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        NSString *headerNameStr  = @"";
        
        for (int i = 0; i < [keyArr count]; i++) {
            NSString *key = keyArr[i];
            NSMutableDictionary *pDic = [NSMutableDictionary dictionaryWithDictionary:headerListDic[key]];
            [pDic setObject:@"1" forKey:@"isSelected"];
            [headerListDic setObject:[pDic copy] forKey:key];
            headerNameStr = [headerNameStr stringByAppendingFormat:@"%@、", [pDic objectForKey:@"realName"]];
        }
        self.selectedHeaderLabel.text = headerNameStr;
    }
    [self.mainTableView reloadData];
}
@end
