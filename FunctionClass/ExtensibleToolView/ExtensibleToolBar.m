//
//  ExtensibleToolBar.m
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "ExtensibleToolBar.h"

@implementation ExtensibleToolBar
@synthesize hasSelectedImage;
@synthesize label;
@synthesize imageNormal;
@synthesize imageSelected;

+ (id)itemWithLabel:(NSString *)inLabel image:(UIImage *)inImage action:(void(^)(void))action {
    ExtensibleToolBar *newItem = [self new];
    [newItem setHasSelectedImage:0];
    [newItem setLabel:inLabel];
    [newItem setImageNormal:inImage];
    [newItem setAction:action];
    return newItem;
}

+ (id)itemWithLabel:(NSString *)inLabel imageNormal:(UIImage *)inImageNormal imageSelected:(UIImage *)inImageSelected action:(void(^)(void))action {
    ExtensibleToolBar *newItem = [self new];
    [newItem setLabel:inLabel];
    [newItem setItemState:0];
    [newItem setHasSelectedImage:1];
    [newItem setImageNormal:inImageNormal];
    [newItem setImageSelected:inImageSelected];
    [newItem setAction:action];
    return newItem;
}

@end
