//
//  SubmitTaskModifyInfoViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "BaseViewController.h"

@protocol SubmitTaskModifyInfoProtocol <NSObject>
- (void)comebackNetValue:(NSDictionary *)value;
@end

@interface SubmitTaskModifyInfoViewController : BaseViewController

@property (nonatomic, strong) id<SubmitTaskModifyInfoProtocol> delegate;
@property (nonatomic, strong) NSString *taskId;

/**
 *  修改任务详情接口
 *
 *  @param modifyStr    修改后的值
 *  @param clickCellTag 所选择的 cell 的 indexPath.row
 */
- (void)submitModifyTask:(NSString *)modifyStr cellTag:(int)clickCellTag;

/**
 *  修改任务附件（图片）
 *
 *  @param sImage  UIImage 类型的图片
 */
- (void)submitModifyImage:(UIImage *)sImage;


/**
 *  关注 等 ToolView 操作
 *
 *  @param modifyStr 需要更改的操作的值
 *  @param index     toolview bar 的 index
 */
- (void)modifyTaskState:(NSString *)modifyStr atIndex:(int)index;

@end
