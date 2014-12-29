//
//  ExtensibleToolView.m
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ExtensibleToolView.h"

#define buttonH 44.0
#define boundsSize [[UIScreen mainScreen] bounds].size

@implementation ExtensibleToolView
@synthesize toolBarArr;
@synthesize buttonArr;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        toolBarIsShow = 0;
        // view 操作
        [self setViewFrame];
        [self setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    }
    return self;
}

- (void)addLinView {
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsSize.width, 1)];
    [linView setBackgroundColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0f]];
    [self addSubview:linView];
}

// 设置 toolView 的位置大小
- (void)setViewFrame {
    [self setFrame:CGRectMake(0, boundsSize.height - 44, boundsSize.width, 44)];
}

#pragma mark - 开始创建子视图

// 创建 ToolView
- (void)setButtonArr:(NSArray *)btnArr {
    toolBarIsShow = 0;
    toolBarArr = [NSMutableArray arrayWithArray:btnArr];
    buttonArr = btnArr;
    buttonWidth = [self gainButtonWidth];
    
    [self createToolView];
}

// 刷新 ToolView，可以将新的 ToolBar 替换旧的 ToolBar
- (void)replaceToolView:(ExtensibleToolBar *)newBar atIndex:(NSInteger)index {
    [toolBarArr replaceObjectAtIndex:index withObject:newBar];
    
    [self removeAllSubView];
    [self createToolView];
}

// 交换 normal 和 selected 图片
- (void)reloadToolView:(NSInteger)index {
    [self removeAllSubView];
    
    ExtensibleToolBar *newBar = toolBarArr[index];
    UIImage *imageSelected = newBar.imageSelected;
    UIImage *imageNormal = newBar.imageNormal;
    newBar.imageNormal = imageSelected;
    newBar.imageSelected = imageNormal;
    newBar.itemState = !newBar.itemState;
    
    [toolBarArr replaceObjectAtIndex:index withObject:newBar];
    
    [self createToolView];
}

// 移除所有子控件
- (void)removeAllSubView {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)createToolView {
    [self addLinView];
    
    // 判断数组个数是否大于5个，如果大于5个，则在第5个位置插入一个 "更多" 按钮
    if ([toolBarArr count] > 5) {
        [self setFrame:CGRectMake(0, boundsSize.height - 44, boundsSize.width, [self gainToolViewHeight:([toolBarArr count] + 1)])];
        [self insertMoreBtn];
    }
    
    for (int i = 0; i < [toolBarArr count]; i++) {
        [self addSubview:[self createNewButton:i ExtensibleToolbBar:toolBarArr[i]]];
    }
}

// 获取 btn 的宽度
- (CGFloat)gainButtonWidth {
    CGFloat btnWidth = 0;
    
    if ([toolBarArr count] <= 5) {
        btnWidth = boundsSize.width / [toolBarArr count];
    } else {
        btnWidth = boundsSize.width / 5;
    }
    
    return btnWidth;
}

// 创建 按钮 和 文字
- (UIView *)createNewButton:(int)viewIndex ExtensibleToolbBar:(ExtensibleToolBar *)toolBar{
    CGFloat toolViewHeight = [self gainToolViewHeight:([toolBarArr count] + 1)];
    
    CGFloat baseViewX = (viewIndex % 5) * buttonWidth;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(baseViewX, buttonH * (viewIndex / 5), buttonWidth, buttonH)];
    [baseView setBackgroundColor:[UIColor clearColor]];
    
    // 新增按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonH)];
    [btn setImage:toolBar.imageNormal forState:UIControlStateNormal];
    if (toolBar.hasSelectedImage) {
        [btn setImage:toolBar.imageSelected forState:UIControlStateSelected];
    }
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(){
        toolBar.action();
        toolBarIsShow = 0;
        [self setFrame:CGRectMake(0, boundsSize.height - 44, boundsSize.width, toolViewHeight)];
    }];
    [baseView addSubview:btn];
    
    // 增加文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonH - 21, buttonWidth, 21)];
    [label setText:toolBar.label];
    [label setTextColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f]];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:label];
    return baseView;
}

// 判断数组个数是否大于5个，如果大于5个，则在第5个位置插入一个更多按钮
- (void)insertMoreBtn {
    CGFloat toolViewHeight = [self gainToolViewHeight:([toolBarArr count] + 1)];
    
    ExtensibleToolBar *moreToolBar = [ExtensibleToolBar itemWithLabel:@"更多" imageNormal:[UIImage imageNamed:@"More_nav"] imageSelected:[UIImage imageNamed:@"More_nav_click"] action:^{
        if (toolBarIsShow) {
            toolBarIsShow = 0;
            [self setFrame:CGRectMake(0, boundsSize.height - 44, boundsSize.width, toolViewHeight)];
        }else {
            toolBarIsShow = 1;
            [self setFrame:CGRectMake(0, boundsSize.height - toolViewHeight, boundsSize.width, toolViewHeight)];
        }
    }];
    
    [toolBarArr insertObject:moreToolBar atIndex:4];
}

// 获取 toolView 的高度
- (CGFloat )gainToolViewHeight:(NSInteger)toolBarNum {
    CGFloat toolViewHeight = 0;
    int toolCellNum = (toolBarNum / 5) + 1;
    
    if ((toolBarNum % 5) == 0 && toolBarNum != 0) {
        toolCellNum --;
    }
    
    toolViewHeight = toolCellNum * buttonH;
    
    return toolViewHeight;
}


@end
