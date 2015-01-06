//
//  BaseViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+CustomExtension.h"
#import "UIKit+CustomExtension.h"
#import "LogInToolClass.h"
#import "UIWindow+YzdHUD.h"
#import "BOAlertController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "CLLocation+YCLocation.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "JHRefresh.h"
#import "CusNavigationTitleView.h"

// Model
#import "UserInfo.h"
#import "ProclamationInfoClass.h"

// 颜色
#define GrayColorForTitle [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f]


#define HttpURL @"http://vmr82ksj.zhy35065.zhihui.chinaccnet.cn/"
#define LogInAction                   @"app_login.action"
#define HomeAction                    @"app_home.action"                   // 获取用户的基本信息

// 考勤
#define AttendanceAction              @"app_attendance.action"
#define AttendanceMonthAction         @"app_attendanceMonth.action"        // 获取当月的用户考勤信息
#define NoticeMonthListAction         @"app_noticeMonthList.action"        // 获取当月公告信息
#define PublishNoticeAction           @"app_publishNotice.action"          // 发布公告
#define NoticeDetailAction            @"app_noticeDetail.action"           // 获取公告详情
#define NoticeAddCommentAction        @"app_noticeAddComment.action"       // 公告添加评论

// 任务
#define TaskHomeAction                @"app_taskHome.action"               // 公司主页接口
#define AllEmployeesAction            @"app_allEmployees.action"           // 获取公司所有人员列表
#define AddTaskAction                 @"app_addTask.action"                // 新建任务
#define TaskDetailAction              @"app_taskDetail.action"             // 任务详情
#define AddTaskContentAction          @"app_addTaskContent.action"         // 修改任务内容
#define ChangeTaskTypeAction          @"app_changeTaskType.action"         // 修改任务类型
#define ChangeTaskJoinUserAction      @"app_changeTaskJoinUser.action"     // 修改任务参与人
#define AddTaskSharedUserAction       @"app_addTaskSharedUser.action"      // 增加或修改任务分享人
#define ChangeTaskAttendionUserAction @"app_changeTaskAttendionUser.action"// 关注任务或取消关注任务
#define AddTaskAccessoryAction        @"app_addTaskAccessory.action"       // 添加任务附件
#define DeleteAccessoryAction         @"app_deleteAccessory.action"        // 删除任务附件和任务汇报控件
#define ChangeTaskStateAction         @"app_changeTaskState.action"        // 修改任务状态
#define DeleteTaskAction              @"app_deleteTask.action"             // 删除任务
#define AddTaskReportAction           @"app_addTaskReport.action"          // 增加任务汇报 or 反馈
#define ChangeTaskStateAction         @"app_changeTaskState.action"        // 修改任务状态(是否完成)
#define TaskDetailLookAction          @"app_taskDetailLook.action"         // 获取任务查阅情况
#define TaskDetailReportAction        @"app_taskDetailReport.action"       // 获取任务汇报
#define AddTaskReportJudgementAction  @"app_addTaskReportJudgement.action" // 添加任务汇报评论
#define AddTaskReportAccessoryAction  @"app_addTaskReportAccessory.action" // 添加任务汇报附件
#define RelateTaskListAction          @"app_relateTaskList.action"         // 获取选择关联任务列表
#define AddRelateTaskAction           @"app_addRelateTask.action"          // 增加或修改关联任务
#define AddTaskReportJudgeAccessoryAction @"app_addTaskReportJudgeAccessory.action" // 添加任务评论反馈附件


// 请假
#define AddLeaveAction                @"app_addLeave.action"               // 新增、编辑请假
#define LeaveHomeAction               @"app_leaveHome.action"              // 请假主页
#define LeaveDetailAction             @"app_leaveDetail.action"            // 请假详情
#define ApproveLeaveAction            @"app_approveLeave.action"           // 审批请假
#define LeaveHistoryAction            @"app_leaveHistory.action"           // 我的历史请假
#define LeaveHistoryApproveAction     @"app_leaveHistoryApprove.action"    // 我的历史审批

// 更多
#define EmployeeInfoAction            @"app_employeeInfo.action"           // 个人资料
#define ChangePwdAction               @"app_changePwd.action"              // 修改密码
#define AutoUpdateIOSAction           @"app_autoUpdateIOS.action"          // IOS检查版本更新



typedef void(^ Failure)();
@interface BaseViewController : UIViewController{
    CGSize keyboardSize;
    NSArray *textFieldArr;
    UserInfo *userInfo;
}

#pragma mark - 设置圆角
- (void)setViewCircleBead:(UIView *)senderView;
- (void)setBtnCircleBead:(UIButton *)senderBtn;

#pragma mark - 网络操作
- (void)createAsynchronousRequest:(NSString *)action parmeters:(NSDictionary *)parmeters success:(void(^)(NSDictionary *dic))success failure:(void(^)())failure;

#pragma mark - 创建简单的警告框
- (void)createSimpleAlertView:(NSString *)title msg:(NSString *)msg;

#pragma mark - 键盘操作
- (void)setCustomKeyboard:(id)delegate;
-(void)hidenKeyboardWithTextField;

#pragma mark - 判断一个数据是不是 NSNull 类型
- (NSString *)judgeTextIsNULL:(id)text;

#pragma mark 去除 tableView 多余的横线
/**
 *  去除 tableView 多余的横线
 *
 *  @param tb 需要去除多余横线的 tableView
 */
- (void)setTableFooterView:(UITableView *)tb;

#pragma mark 判断输入框是否全部有输入
/**
 *  判断输入框是否全部有输入
 *
 *  @param textFieldArr 输入框的集合
 *
 *  @return 全部有输入： 返回 yes;  有一个没有输入：返回 NO;
 */
- (BOOL)TextFieldIsFull:(NSArray *)textFieldArr;




@end
