//
//  UIButton+ExtensionWithUIButton.m
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "UIButton+ExtensionWithUIButton.h"

@implementation UIButton (ExtensionWithUIButton)


#pragma mark - 将 BUtton 与 Block 结合
static char overviewKey;
@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end
