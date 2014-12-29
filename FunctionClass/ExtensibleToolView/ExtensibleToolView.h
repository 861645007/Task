//
//  ExtensibleToolView.h
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtensibleToolBar.h"
#import "UIButton+ExtensionWithUIButton.h"

@interface ExtensibleToolView : UIView {
    CGFloat buttonWidth;
    int toolBarIsShow;           // 0：没有展开   1：展开了
    
}
@property (nonatomic, strong) NSMutableArray *toolBarArr;
@property (nonatomic, strong) NSArray *buttonArr;

/**
 *  刷新 ToolView，可以将新的 ToolBar 替换旧的 ToolBar
 *
 *  @param newBar  新的 ToolBar
 *  @param index   替换的位置
 */
- (void)replaceToolView:(ExtensibleToolBar *)newBar atIndex:(NSInteger)index;

// 交换 normal 和 selected 图片
- (void)reloadToolView:(NSInteger)index;
@end
