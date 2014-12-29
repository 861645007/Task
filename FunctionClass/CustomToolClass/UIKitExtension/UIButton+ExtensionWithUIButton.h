//
//  UIButton+ExtensionWithUIButton.h
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)();

@interface UIButton (ExtensionWithUIButton)


// 将 BUtton 与 Block 结合
@property (readonly) NSMutableDictionary *event;

/**
 *  触发事件
 *
 *  @param controlEvent 触发事件的方式（UIControlEvents）
 *  @param action       需要触发的时间
 */
- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
