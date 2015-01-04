//
//  TaskDetailInfoTableViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/20.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "TaskDetailInfoTableViewController.h"
#import "SubTaskTableViewController.h"

@interface TaskDetailInfoTableViewController () {
    NSMutableDictionary *taskDetailInfoDic;
    NSMutableArray *relationTasksArr;      // 关联任务
    NSMutableArray *taskAccessorysArr;     // 任务附件
    NSMutableArray *attentionTaskUsersArr; // 任务关注人列表
    NSMutableArray *joinTaskUsersArr;      // 参与人列表
    NSMutableArray *shareTaskUsersArr;     // 分享人列表
    NSMutableArray *taskReportArr;         // 任务汇报列表
    NSMutableArray *taskLookDetailArr;     // 任务查阅列表
    NSMutableArray *subTaskList;           // 子任务列表
    
    int isDelete;                          // 0表示没有进行删除操作， 1表示进行了删除操作
    int isNeedRefresh;                     // 是否需要刷新数据  0表示需要刷新， 1表示不需要刷新
    int section1ISselected;                // 用来判断辅助信息那一栏是否展开 ， 0：为展开； 1：展开
    int clickCellTag;                      // 判断所选择的 cell 是哪一个
    int modifyContextIndex;                // 用来表示修改了哪一个内容，其值分别为 对应上传方法的 index
    int isReportViewOrLookView;            // 0：表示 ReportView， 1：表示 LookView
    ExtensibleToolView *toolView;
}

@end

@implementation TaskDetailInfoTableViewController
@synthesize mainTableView;
@synthesize taskId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    taskDetailInfoDic = [NSMutableDictionary dictionary];
    relationTasksArr  = [NSMutableArray array];
    taskAccessorysArr = [NSMutableArray array];
    attentionTaskUsersArr = [NSMutableArray array];
    joinTaskUsersArr = [NSMutableArray array];
    shareTaskUsersArr = [NSMutableArray array];
    taskReportArr = [NSMutableArray array];
    taskLookDetailArr = [NSMutableArray array];
    subTaskList = [NSMutableArray array];
    
    section1ISselected = 0;
    clickCellTag = 0;
    isReportViewOrLookView = 0;
    isDelete = 0;
    // 添加底部 ToolView
    [self createToolView];
    
    // 去除 tableView 多余的横线
    [self setTableFooterView:mainTableView];
    
    // 注册刷新控件
    [self.mainTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [self gainTaskDetailInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([taskDetailInfoDic isEqualToDictionary:@{}] || isNeedRefresh == 0) {
        isNeedRefresh = 1;
        [self gainTaskDetailInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加底部 ToolBar
- (void)createToolView {
    toolView = [[ExtensibleToolView alloc] init];
    
    ExtensibleToolBar *attentionBar = [self addAttentionBar];
    ExtensibleToolBar *feedbackBar  = [self addFeedbackBar];
    ExtensibleToolBar *completeBar  = [self addCompleteBar];
    ExtensibleToolBar *shareBar     = [self addShareBar];
    ExtensibleToolBar *deleteBar    = [self addDeleteBar];
    toolView.buttonArr = @[attentionBar, feedbackBar, completeBar, shareBar, deleteBar];
    [self.view addSubview:toolView];
}

- (SubmitTaskModifyInfoViewController *)createSubmitTaskModifyInfoViewController {
    SubmitTaskModifyInfoViewController *submitTaskModifyInfoViewController = [[SubmitTaskModifyInfoViewController alloc] init];
    submitTaskModifyInfoViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
    submitTaskModifyInfoViewController.delegate = self;
    
    return submitTaskModifyInfoViewController;
}

// 关注 按钮
- (ExtensibleToolBar *)addAttentionBar {
    ExtensibleToolBar *attentionBar = [ExtensibleToolBar itemWithLabel:@"关注" imageNormal:[UIImage imageNamed:@"Attention_nav"] imageSelected:[UIImage imageNamed:@"Attention_ok_nav"] action:^(){
        [toolView reloadToolView:0];
        ExtensibleToolBar *curreentItem = toolView.toolBarArr[0];
        [[self createSubmitTaskModifyInfoViewController] modifyTaskState:[NSString stringWithFormat:@"%d", curreentItem.itemState] atIndex:0];
    }];
    
    return attentionBar;
}

// 反馈 按钮
- (ExtensibleToolBar *)addFeedbackBar {
    ExtensibleToolBar *feedbackBar = [ExtensibleToolBar itemWithLabel:@"反馈" imageNormal:[UIImage imageNamed:@"Feedback_nav"] imageSelected:[UIImage imageNamed:@"Feedback_nav_click"] action:^(){
        // 跳转反馈页面
        modifyContextIndex = 1;
        isNeedRefresh = 0;
        AddTaskReportJudgementViewController *addTaskReportJudgementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskReportJudgementViewController"];
        addTaskReportJudgementViewController.isFeedBackOrJudgement = 0;
        addTaskReportJudgementViewController.titleStr = @"反馈";
        addTaskReportJudgementViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
        [self.navigationController pushViewController:addTaskReportJudgementViewController animated:YES];
    }]; 
    
    return feedbackBar;
}

// 完成 按钮
- (ExtensibleToolBar *)addCompleteBar {
    ExtensibleToolBar *completeBar = [ExtensibleToolBar itemWithLabel:@"完成" imageNormal:[UIImage imageNamed:@"Complete_nav"] imageSelected:[UIImage imageNamed:@"Complete_ok_nav"] action:^(){
        [toolView reloadToolView:2];
        ExtensibleToolBar *curreentItem = toolView.toolBarArr[2];
        [[self createSubmitTaskModifyInfoViewController] modifyTaskState:[NSString stringWithFormat:@"%d", curreentItem.itemState] atIndex:2];

    }];
    return completeBar;
}

// 分享 按钮
- (ExtensibleToolBar *)addShareBar {
    ExtensibleToolBar *shareBar = [ExtensibleToolBar itemWithLabel:@"分享" imageNormal:[UIImage imageNamed:@"Share_nav"] imageSelected:[UIImage imageNamed:@"Share_nav_click"] action:^(){
        // 调到选择界面
        [self sureClickCellTag:1 row:2];
        [self gainToSelectedPersonView:1 title:@"共享人"];
    }];
    return shareBar;
}

// 删除 按钮
- (ExtensibleToolBar *)addDeleteBar {
    ExtensibleToolBar *deleteBar = [ExtensibleToolBar itemWithLabel:@"删除" imageNormal:[UIImage imageNamed:@"Delete_nav"] imageSelected:[UIImage imageNamed:@"Delete_nav_click"] action:^(){
        isDelete = 1;
        ExtensibleToolBar *curreentItem = toolView.toolBarArr[4];
        [[self createSubmitTaskModifyInfoViewController] modifyTaskState:[NSString stringWithFormat:@"%d", curreentItem.itemState] atIndex:4];
    }];
    return deleteBar;
}


#pragma mark - 获取数据
// 获取数据
- (void)gainTaskDetailInfo {
    [self.view.window showHUDWithText:@"获取详情" Type:ShowLoading Enabled:YES];
    NSString *employeeId     = [userInfo gainUserId];
    NSString *realName       = [userInfo gainUserName];
    NSString *enterpriseId   = [userInfo gainUserEnterpriseId];
    //参数
    NSDictionary *parameters = @{@"employeeId": employeeId,
                                 @"realName":realName,
                                 @"enterpriseId": enterpriseId,
                                 @"taskId": taskId};

    [self createAsynchronousRequest:TaskDetailAction parmeters:parameters success:^(NSDictionary *dic){
        [self dealWithTaskDetailInfoResult: dic];
    } failure:^{
        // 事情做完了, 结束刷新动画~~~
        [mainTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
    }];
}

//处理网络操作结果
- (void)dealWithTaskDetailInfoResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"获取详情成功" Type:ShowPhotoYes Enabled:YES];
            [self dealData:dic];
            [mainTableView reloadData];
            
            break;
        }
    }
    // 事情做完了, 结束刷新动画~~~
    [mainTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)dealData:(NSDictionary *)dic {
    taskDetailInfoDic     = [dic objectForKey:@"taskDetail"];
    [self updateCompleteItemState:[[dic objectForKey:@"state"] intValue]];
    relationTasksArr      = [taskDetailInfoDic objectForKey:@"relationTasks"];
    taskAccessorysArr     = [taskDetailInfoDic objectForKey:@"taskAccessorys"];
    attentionTaskUsersArr = [taskDetailInfoDic objectForKey:@"attentionTaskUsers"];
    [self updateAttentionItemState];
    joinTaskUsersArr      = [taskDetailInfoDic objectForKey:@"joinTaskUsers"];
    shareTaskUsersArr     = [taskDetailInfoDic objectForKey:@"shareTaskUsers"];
    subTaskList           = [taskDetailInfoDic objectForKey:@"childrenTasks"];
    
    [self updateReportInfo:TaskDetailReportAction cellIndex:0];
    [self updateReportInfo:TaskDetailLookAction cellIndex:1];
}

// 更新 关注 bar 的状态
- (void)updateAttentionItemState {
    NSString *myId = [userInfo gainUserId];
    for (NSDictionary *dic in attentionTaskUsersArr) {
        if ([myId isEqualToString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"attentionId"]]]) {
            ExtensibleToolBar *currentItem = toolView.toolBarArr[0];
            if (!currentItem.itemState) {
                [toolView reloadToolView:0];
            }
            break;
        }
    }
}

// 更新 完成 bar 的状态
- (void)updateCompleteItemState:(int)completeState {
    if (completeState == 2 || completeState == 3) {
        ExtensibleToolBar *currentItem = toolView.toolBarArr[2];
        if (!currentItem.itemState) {
            [toolView reloadToolView:2];
        }
    }
}

#pragma mark - 加载 评论 及 查阅 的数据
- (void)updateReportInfo:(NSString *)action cellIndex:(int)cellIndex {
    NSString *employeeId   = [[UserInfo shareInstance] gainUserId];
    NSString *realName     = [[UserInfo shareInstance] gainUserName];
    NSString *enterpriseId = [[UserInfo shareInstance] gainUserEnterpriseId];
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"employeeId": employeeId, @"realName":realName, @"enterpriseId": enterpriseId, @"taskId": taskId}];
    
    [self createAsynchronousRequest:action parmeters:parameters success:^(NSDictionary *dic){
        if (cellIndex == 0) {
            taskReportArr = [dic objectForKey:@"taskReports"];
            [self.mainTableView reloadData];
        }else if (cellIndex == 1) {
            taskLookDetailArr = [dic objectForKey:@"taskLooks"];
        }
    } failure:^{}];
    
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        if (section1ISselected) {
            return 6;
        }
        return 0;
    }else if (section == 3) {
        if (isReportViewOrLookView == 0) {
            return [taskReportArr count];
        }else if (isReportViewOrLookView == 1) {
            return [taskLookDetailArr count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0  && indexPath.row == 0) {
        return 80;
    } else if (indexPath.section == 1  && indexPath.row == 4) {
        return 44 * (relationTasksArr.count + 1);
    } else if (indexPath.section == 1  && indexPath.row == 5) {
        return 44 * (taskAccessorysArr.count + 1);
    } else if (indexPath.section == 3) {
        if (isReportViewOrLookView == 0) {
            return [self setSection3CellHeight:indexPath];
        }else {
            return 60;
        }
    }
    return  44;
}

// 设置 section 即反馈的 cell 的高度
- (CGFloat)setSection3CellHeight:(NSIndexPath *)indexPath {

    NSDictionary *dic = [taskReportArr objectAtIndex:indexPath.row];
    CGFloat descHeight = [self textHeight:[dic objectForKey:@"desc"]];

    // 获取字符串
    NSString *contentText = @"";
    for (NSDictionary *reportContentDic in [dic objectForKey:@"reportJudges"]) {
        contentText = [contentText stringByAppendingFormat:@"@%@ %@ \n", [reportContentDic objectForKey:@"judgedUserName"], [reportContentDic objectForKey:@"judgeContent"]];
    }
    
    CGFloat accessoryH = [[dic objectForKey:@"reportAccessorys"] count] * 30;
    // 获取并设置高度
    CGFloat contentH = [self textHeight:contentText];
    
    return 35 + descHeight + contentH + accessoryH + 27;
}

// 获取 label 实际所需要的高度
- (CGFloat)textHeight:(NSString *)labelText {
    UIFont *tfont = [UIFont systemFontOfSize:13.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //  ios7 的API，判断 labelText 这个字符串需要的高度；    这里的宽度（self.view.frame.size.width - 140he）按照需要自己换就 OK
    CGSize sizeText = [labelText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 62, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    if ([labelText isEqualToString:@""]) {
        return 0;
    }
    return sizeText.height;
}

#pragma mark - 定义头标题的视图，添加点击事件
// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    sectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [lineView1 setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f]];
    [sectionView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f]];
    [sectionView addSubview:lineView2];
    
    UIButton *backgroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    backgroundBtn.tag = section;
    [backgroundBtn addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:backgroundBtn];
    
    if (section == 1 || section == 2) {
        // 设置 section 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 21, 320, 21)];
        titleLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"辅助信息";
        [titleLabel sizeToFit];
        [sectionView addSubview:titleLabel];
        
        // 设置 section 标题
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 57, 21, 20, 44)];
        detailLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f];
        detailLabel.text = @"展开";
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.tag = section + 10;
        [detailLabel sizeToFit];
        
        // 设置图标
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36, 20, 15, 15)];
        imageView.tag = 201;
        
        // 判断 cell 右边显示的数据
        if (section1ISselected == 0) {
            imageView.image = [UIImage imageNamed:@"Pulldown"];
            detailLabel.text = @"展开";
        }else {
            imageView.image = [UIImage imageNamed:@"pullback"];
            detailLabel.text = @"隐藏";
        }
        
        if (section == 2) {
            titleLabel.text = @"子任务";
            detailLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)[subTaskList count]];
            [imageView setImage:[UIImage imageNamed:@"pullback"]];
        }
        
        [sectionView addSubview:detailLabel];
        [sectionView addSubview:imageView];
        return sectionView;
    }else if (section == 3) {
        UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 90, 43)];
        [reportButton setTitle:@"反馈及评论" forState:UIControlStateNormal];
        [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reportButton.titleLabel.font = [UIFont systemFontOfSize:14];
        reportButton.tag = 101;
        [reportButton addTarget:self action:@selector(SelectedReportOrLookView:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:reportButton];
        
        UIView *blockLineViewWithReport = [[UIView alloc] initWithFrame:CGRectMake(14, 44 - 3, 77, 3)];
        blockLineViewWithReport.tag = 1002;
        [blockLineViewWithReport setBackgroundColor:[UIColor blackColor]];
        [sectionView addSubview:blockLineViewWithReport];
        
        UIButton *lookButton = [[UIButton alloc] initWithFrame:CGRectMake(92, 0, 90, 43)];
        [lookButton setTitle:@"查阅情况" forState:UIControlStateNormal];
        [lookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lookButton.titleLabel.font = [UIFont systemFontOfSize:14];
        lookButton.tag = 103;
        [lookButton addTarget:self action:@selector(SelectedReportOrLookView:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:lookButton];
        
        UIView *blockLineViewWithLook = [[UIView alloc] initWithFrame:CGRectMake(102, 44 - 3, 72, 3)];
        blockLineViewWithLook.tag     = 1004;
        [blockLineViewWithLook setBackgroundColor:[UIColor blackColor]];
        [sectionView addSubview:blockLineViewWithLook];
        
        if (isReportViewOrLookView) {
            blockLineViewWithReport.hidden = YES;
            blockLineViewWithLook.hidden = NO;
        }else {
            blockLineViewWithReport.hidden = NO;
            blockLineViewWithLook.hidden = YES;
        }
        
        return sectionView;
    }
    return nil;
}

- (void)sectionAction:(UIButton *)btn {
    if (btn.tag == 1) {
        if (section1ISselected) {
            section1ISselected = 0;
        }else {
            section1ISselected = 1;
        }
        
        // 刷新点击的组标题，动画使用卡片
        [mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    }else if (btn.tag == 2) {
        SubTaskTableViewController *subTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"SubTaskTableViewController"];
        subTaskView.subTaskList = subTaskList;
        subTaskView.superTaskId = taskId;
        [self.navigationController pushViewController:subTaskView animated:YES];
    }
}

// 选择评论 TableView or 查询情况
- (void)SelectedReportOrLookView:(UIButton *)btn {
    if (btn.tag == 101) {
        isReportViewOrLookView = 0;
    }else if (btn.tag == 103) {
        isReportViewOrLookView = 1;
    }
    [self.mainTableView reloadData];
}

#pragma mark - cellForRowAtIndexPath 添加 cell 方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"";
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellIdentifier = @"TaskDetailInfoCell";
            TaskDetailInfoTableViewCell *taskDetailInfoCell = (TaskDetailInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            taskDetailInfoCell.taskCreaterNameLabel.text = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"createName"]];
            taskDetailInfoCell.taskTimeLabel.text = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"createTime"]];
            taskDetailInfoCell.taskTitleLabel.text = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"title"]];
            int taskType = [[taskDetailInfoDic objectForKey:@"type"] intValue];
            if (taskType == 0) {
                taskDetailInfoCell.taskTitleLabel.textColor = [UIColor blackColor];
            } else if (taskType == 1) {
                taskDetailInfoCell.taskTitleLabel.textColor = [UIColor orangeColor];
            } else if (taskType == 2) {
                taskDetailInfoCell.taskTitleLabel.textColor = [UIColor redColor];
            }
            
            // 内容的设置
            NSString *content = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"content"]];
            if ([content isEqualToString:@""]) {
                taskDetailInfoCell.taskContextLabel.text = @"请输入备注";
                taskDetailInfoCell.taskContextLabel.textColor = GrayColorForTitle;
            }else {
                taskDetailInfoCell.taskContextLabel.text = content;
                taskDetailInfoCell.taskContextLabel.textColor = [UIColor blackColor];
            }
            
            cell = taskDetailInfoCell;
        }else {
            cellIdentifier = @"TaskOtherDetailInfoCell";
            
            TaskOtherDetailInfoTableViewCell *taskOtherDetailInfoCell = (TaskOtherDetailInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                // 使用 Xib 代替
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TaskOtherDetailInfoTableViewCell" owner:self options:nil];
                taskOtherDetailInfoCell = [nib objectAtIndex:0];
            }
            
            if (indexPath.row == 1) {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"负责人:";
                taskOtherDetailInfoCell.otherDetailInfoLabel.text = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"principalName"]];
            }else if (indexPath.row == 2) {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"到期日:";
                taskOtherDetailInfoCell.otherDetailInfoLabel.text = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"endTime"]];
            }
            cell = taskOtherDetailInfoCell;
        }
        
    }else if(indexPath.section == 1) {
        cellIdentifier = @"TaskOtherDetailInfoCell";
        
        TaskOtherDetailInfoTableViewCell *taskOtherDetailInfoCell = (TaskOtherDetailInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            // 使用 Xib 代替
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TaskOtherDetailInfoTableViewCell" owner:self options:nil];
            taskOtherDetailInfoCell = [nib objectAtIndex:0];
        }

        switch (indexPath.row) {
            case 0: {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"紧急程度:";
                int taskType = [[taskDetailInfoDic objectForKey:@"type"] intValue];
                NSString *taskTypeText = @"";
                if (taskType == 0) {
                    taskTypeText = @"普通";
                    taskOtherDetailInfoCell.otherDetailInfoLabel.textColor = [UIColor blackColor];
                } else if (taskType == 1) {
                    taskTypeText = @"紧急";
                    taskOtherDetailInfoCell.otherDetailInfoLabel.textColor = [UIColor orangeColor];
                } else if (taskType == 2) {
                    taskTypeText = @"非常紧急";
                    taskOtherDetailInfoCell.otherDetailInfoLabel.textColor = [UIColor redColor];
                }
                taskOtherDetailInfoCell.otherDetailInfoLabel.text = taskTypeText;
                break;
            }
            case 1: {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"参与人:";
                [self gainTextWithArr:joinTaskUsersArr title:@"参与人" key:@"join" label:taskOtherDetailInfoCell.otherDetailInfoLabel];
            }
                break;
            case 2: {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"共享人:";
                [self gainTextWithArr:shareTaskUsersArr title:@"共享人" key:@"share" label:taskOtherDetailInfoCell.otherDetailInfoLabel];
            }
                break;
            case 3: {
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"关注人:";
                [self gainTextWithArr:attentionTaskUsersArr title:@"关注人" key:@"attention" label:taskOtherDetailInfoCell.otherDetailInfoLabel];
            }
                break;
            case 4: {
                [self addNewView:taskOtherDetailInfoCell cellIndex:indexPath.row data:relationTasksArr dictionaryKey:@"relationTitle" lastText:@"修改相关信息"];
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"关联:";
            }
                break;
            case 5: {
                [self addNewView:taskOtherDetailInfoCell cellIndex:indexPath.row data:taskAccessorysArr dictionaryKey:@"accessoryName" lastText:@"上传附件"];
                taskOtherDetailInfoCell.otherDetailInfoTitleLabel.text = @"附件:";
            }
                break;
            default:
                break;
        }

        cell = taskOtherDetailInfoCell;
    } else if (indexPath.section == 3) {
        if (isReportViewOrLookView == 0) {
            cellIdentifier = @"TaskReportCell";
            
            TaskReportTableViewCell *taskReportCell = (TaskReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                // 使用 Xib 代替
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TaskReportTableViewCell" owner:self options:nil];
                taskReportCell = [nib objectAtIndex:0];
            }
            
            NSDictionary *dic = [taskReportArr objectAtIndex:indexPath.row];
            taskReportCell.reportPersonNameLabel.text= [dic objectForKey:@"reportPersonName"];
            taskReportCell.reportTimeLabel.text = [dic objectForKey:@"reportTime"];
            taskReportCell.reportContentLabel.text = [dic objectForKey:@"desc"];

            taskReportCell.reportPersonIconImageView.image = [taskReportCell gainUserIcon:[dic objectForKey:@"reportPersonId"]];
            
            [taskReportCell setAutoHeight:[dic objectForKey:@"reportJudges"] reportAccessorysList:[dic objectForKey:@"reportAccessorys"] taskContentText:[dic objectForKey:@"desc"] baseViewController:self];
            taskReportCell.reportReplyBtn.tag = indexPath.row;
            [taskReportCell.reportReplyBtn addTarget:self action:@selector(addTaskReportJudgement:) forControlEvents:UIControlEventTouchUpInside];
            
            cell = taskReportCell;
        }else if (isReportViewOrLookView == 1) {
            cellIdentifier = @"TaskLookDetailCell";

            TaskLookDetailTableViewCell *taskLookDetailCell = (TaskLookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TaskLookDetailTableViewCell" owner:self options:nil];
                taskLookDetailCell = [nib objectAtIndex:0];
            }
            NSDictionary *dic = [taskLookDetailArr objectAtIndex:indexPath.row];
            taskLookDetailCell.lookTaskContentLabel.text = [dic objectForKey:@"isLook"];
            taskLookDetailCell.lookTaskPersonNameLabel.text = [dic objectForKey:@"realName"];
            taskLookDetailCell.lookTaskTimeLabel.text = [dic objectForKey:@"lookTime"];
            
            cell = taskLookDetailCell;
        }
    }
    
    return cell;
}

// 评论回复接口
- (void)addTaskReportJudgement:(UIButton *)btn {
    isNeedRefresh = 0;
    NSDictionary *dic = [taskReportArr objectAtIndex:btn.tag];
    
    AddTaskReportJudgementViewController *addTaskReportJudgementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskReportJudgementViewController"];
    addTaskReportJudgementViewController.isFeedBackOrJudgement = 1;
    addTaskReportJudgementViewController.titleStr = @"评论";
    addTaskReportJudgementViewController.taskReportId = [dic objectForKey:@"taskReportId"];
    addTaskReportJudgementViewController.judgedUserId = [dic objectForKey:@"reportPersonId"];
    addTaskReportJudgementViewController.judgedUserName = [dic objectForKey:@"reportPersonName"];
    [self.navigationController pushViewController:addTaskReportJudgementViewController animated:YES];
}

// 向相应 cell 中新增控件
- (void)addNewView:(TaskOtherDetailInfoTableViewCell *)cell cellIndex:(NSInteger)cellIndex data:(NSArray *)dataArr dictionaryKey:(NSString *)keyStr lastText:(NSString *)lastTextStr {
    // 清楚试图中的原有控件
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    cell.otherDetailInfoLabel.hidden = YES;
    
    int originX = 80;
    int originY = 0;
    int sizeW = self.view.frame.size.width - 88;
    int sizeH = 43;
    
    int i = 0;
    for (NSDictionary *dic in dataArr) {
        // 添加 btn；
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
        button.titleLabel.textAlignment   = NSTextAlignmentLeft;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
        button.tag                        = i;
        [button setTitle:[dic objectForKey:keyStr] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (cellIndex == 4) {
            [button addTarget:self action:@selector(showRelateTaskInfo:) forControlEvents:UIControlEventTouchUpInside];
        }else if (cellIndex == 5) {
            [button addTarget:self action:@selector(lookoverAccessAry:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.contentView addSubview:button];
        originY += sizeH;
        
        // 添加底线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, sizeW, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0f]];
        [cell.contentView addSubview:lineView];
        originY += 1;
        
        i++;
    }

    UIButton *cusButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, sizeW, sizeH)];
    cusButton.titleLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:15];
    cusButton.titleLabel.textAlignment   = NSTextAlignmentLeft;
    cusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cusButton setTitle:lastTextStr forState:UIControlStateNormal];
    [cusButton setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f] forState:UIControlStateNormal];
    if (cellIndex == 4) {
        [cusButton addTarget:self action:@selector(modifyTaskRelationInfo) forControlEvents:UIControlEventTouchUpInside];
    }else if (cellIndex == 5) {
        [cusButton addTarget:self action:@selector(clickTaskAccessorysBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    cusButton.tag = i;
    [cell.contentView addSubview:cusButton];
}

- (void)showRelateTaskInfo:(UIButton *)btn {
    TaskDetailInfoTableViewController *taskDetailInfoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailInfoTableViewController"];
    taskDetailInfoTableViewController.taskId = [[relationTasksArr objectAtIndex:btn.tag] objectForKey:@"relationId"];
    [self.navigationController pushViewController:taskDetailInfoTableViewController animated:YES];
}

- (void)lookoverAccessAry:(UIButton *)btn {
    isNeedRefresh = 0;
    
    NSDictionary *accessAryDic = [taskAccessorysArr objectAtIndex:btn.tag];
    PreviewFileViewController *previewFileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewFileViewController"];
    previewFileViewController.isTaskOrReportAccessory = 0;
    previewFileViewController.accessoryId = [accessAryDic objectForKey:@"accessoryId"];
    previewFileViewController.fileName = [accessAryDic objectForKey:@"accessoryTempName"];
    [self.navigationController pushViewController:previewFileViewController animated:YES];
}

// 修改关联
- (void)modifyTaskRelationInfo {
    isNeedRefresh = 0;
    RelateTaskListViewController *relateTaskListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RelateTaskListViewController"];
    relateTaskListViewController.taskId = taskId;
    [self.navigationController pushViewController:relateTaskListViewController animated:YES];
}

// 选取照片
- (void)clickTaskAccessorysBtn {
    BOAlertController *sheetAction = [[BOAlertController alloc] initWithTitle:@"请选择上传附件方式" message:nil subView:nil viewController:self];
    RIButtonItem *cameraItem = [RIButtonItem itemWithLabel:@"拍照获取" action:^(){
        [self pickImageFromCamera];
    }];
    [sheetAction addButton:cameraItem type:RIButtonItemType_Other];
    
    RIButtonItem *albumItem = [RIButtonItem itemWithLabel:@"相册获取" action:^(){
        GetAllPhotoCollectionViewController *allPhotoCollectionView = [[GetAllPhotoCollectionViewController alloc] initWithCollectionViewLayout:[self setCollectionViewController]];
        allPhotoCollectionView.delegate = self;
        [self.navigationController pushViewController:allPhotoCollectionView animated:YES];
    }];
    [sheetAction addButton:albumItem type:RIButtonItemType_Other];

    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:^(){}];
    [sheetAction addButton:cancelItem type:RIButtonItemType_Cancel];
    
    [sheetAction showInView:self.view];
}

- (void)pickImageFromCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        NSLog(@"你这是模拟器！");
    }
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

- (UICollectionViewFlowLayout *)setCollectionViewController {
    CGFloat cellWidth = (self.view.frame.size.width - 5 * 6) / 3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(cellWidth, cellWidth)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    flowLayout.minimumLineSpacing = 5;
    
    return flowLayout;
}

// 判断 text 时候有内容
- (void)gainTextWithArr:(NSArray *)arr title:(NSString *)titleStr key:(NSString *)key label:(UILabel *)label {
    // 设置 dic 中的 key
    NSString *keyStr = [NSString stringWithFormat:@"%@Name", key];
    NSString *hasContent = @"0";
    
    // 设置 label 中的 内容
    NSString *text = @"";
    if ([arr isEqualToArray:@[]]) {
        text = [NSString stringWithFormat:@"选择%@", titleStr];
        label.textColor = GrayColorForTitle;
    }else {
        hasContent = @"1";
        label.textColor = [UIColor blackColor];
        for (NSDictionary *dic in arr) {
            if ([dic isEqual:[arr lastObject]]) {
                text = [text stringByAppendingFormat:@"%@", [dic objectForKey:keyStr]];
            }else {
                text = [text stringByAppendingFormat:@"%@，", [dic objectForKey:keyStr]];
            }
            
        }
    }
    label.text = text;
}


#pragma mark - 点击 cell 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                [self sureClickCellTag:indexPath.section row:indexPath.row];
                modifyContextIndex = 5;
                NSString *content = [self judgeTextIsNULL:[taskDetailInfoDic objectForKey:@"content"]];
                [self modifyTaskContext:@"备注" content:content];
            }
                break;
            case 1: {
//                [self sureClickCellTag:indexPath.section row:indexPath.row];
//                [self gainToSelectedPersonView:0];
            }
                break;
            case 2: {
//                [self sureClickCellTag:indexPath.section row:indexPath.row];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                [self sureClickCellTag:indexPath.section row:indexPath.row];
                ModifyUrgentLevelViewController *modifyUrgentLevelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyUrgentLevelViewController"];
                modifyUrgentLevelViewController.urgentStr = [taskDetailInfoDic objectForKey:@"type"];
                modifyUrgentLevelViewController.delegate  = self;
                [self.navigationController pushViewController:modifyUrgentLevelViewController animated:YES];
            }
                break;
            case 1: {
                [self sureClickCellTag:indexPath.section row:indexPath.row];
                [self gainToSelectedPersonView:1 title:@"参与人"];
            }
                break;
            case 2: {
                [self sureClickCellTag:indexPath.section row:indexPath.row];
                [self gainToSelectedPersonView:1 title:@"共享人"];
            }
                break;
            case 3: {
                [self sureClickCellTag:indexPath.section row:indexPath.row];
            }
                break;
            default:
                break;
        }
    }

}

// 确定 cell 的 tag
- (void)sureClickCellTag:(NSInteger)section row:(NSInteger)row {
    clickCellTag = (int)section * 10 + (int)row;
}

// 滚到选择人物界面
- (void)gainToSelectedPersonView:(int)isRadio title:(NSString *)titleStr {
    SelectHeaderViewController *selected = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectHeaderViewController"];
    selected.viewTitle = titleStr;
    selected.delegate  = self;
    selected.isRadio   = isRadio;
    [self.navigationController pushViewController:selected animated:YES];
}

// 修改 内容 等
- (void)modifyTaskContext:(NSString *)titleStr content:(NSString *)contentStr {    
    ModifyTaskTitleViewController *modifyTaskTitleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyTaskTitleViewController"];
    modifyTaskTitleViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
    modifyTaskTitleViewController.title = titleStr;
    modifyTaskTitleViewController.delegate = self;
    modifyTaskTitleViewController.taskContent = contentStr;
    [self.navigationController pushViewController:modifyTaskTitleViewController animated:YES];
}

#pragma mark - 选择负责人 or 参与人 or 共享人 和 选择任务紧急程度
// 选择负责人 or 参与人 or 共享人
- (void)selectedHeader:(NSArray *)headerList {
    NSString *headerIdListStr = @"";
    for (NSDictionary *dic in headerList) {
        if ([dic isEqual:[headerList lastObject]]) {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@",[dic objectForKey:@"employeeId"]];
            
        }else {
            headerIdListStr = [headerIdListStr stringByAppendingFormat:@"%@,",[dic objectForKey:@"employeeId"]];
        }
    }
    
    [self submitModifyTaskInfo:headerIdListStr];
}

// 选择任务紧急程度
- (void)selectedUrgentLevel:(NSString *)urgentLevel {
    [self submitModifyTaskInfo:urgentLevel];
}

// 提交协议
- (void)submitModifyTaskInfo:(NSString *)modifyTaskStr {
    [self.view.window showHUDWithText:@"提交详情" Type:ShowLoading Enabled:YES];
    
    SubmitTaskModifyInfoViewController *submitTaskModifyInfoViewController = [[SubmitTaskModifyInfoViewController alloc] init];
    submitTaskModifyInfoViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
    submitTaskModifyInfoViewController.delegate = self;
    
    [submitTaskModifyInfoViewController submitModifyTask:modifyTaskStr cellTag:clickCellTag];
}

#pragma mark - 从相册获取图片
- (void)selectedPhoto:(NSArray *)imageList {
    SubmitTaskModifyInfoViewController *submitTaskModifyInfoViewController = [[SubmitTaskModifyInfoViewController alloc] init];
    submitTaskModifyInfoViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
    submitTaskModifyInfoViewController.delegate = self;

    for (UIImage *image in imageList) {
        [submitTaskModifyInfoViewController submitModifyImage:image];
    }
}

#pragma mark - 从照相机获取照片 image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [self.view.window showHUDWithText:@"提交附件" Type:ShowLoading Enabled:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    SubmitTaskModifyInfoViewController *submitTaskModifyInfoViewController = [[SubmitTaskModifyInfoViewController alloc] init];
    submitTaskModifyInfoViewController.taskId = [taskDetailInfoDic objectForKey:@"taskId"];
    submitTaskModifyInfoViewController.delegate = self;
    [submitTaskModifyInfoViewController submitModifyImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 处理提交结果
- (void)comebackNetValue:(NSDictionary *)value {
    [self dealWithModifyTaskResult:value];
}

#pragma mark - 修改
- (void)modifyTaskContextInfo:(NSString *)taskContext {
    [[self createSubmitTaskModifyInfoViewController] modifyTaskState:taskContext atIndex:modifyContextIndex];
}

//处理网络操作结果
- (void)dealWithModifyTaskResult:(NSDictionary *)dic {
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = [dic objectForKey:@"message"];
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"修改成功" Type:ShowPhotoYes Enabled:YES];
            if (isDelete) {
                [self performSelector:@selector(comeback) withObject:nil afterDelay:0.9];
            }else {
                [self performSelector:@selector(gainTaskDetailInfo) withObject:nil afterDelay:0.9];
            }
            
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:true];
    }
}

- (void)comeback {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
