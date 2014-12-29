//
//  ExtensibleToolBar.h
//  Task
//
//  Created by wanghuanqiang on 14/12/26.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ExtensibleToolBar : NSObject

@property (nonatomic) int hasSelectedImage;
@property (nonatomic) int itemState;
@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) UIImage *imageNormal;
@property (retain, nonatomic) UIImage *imageSelected;
@property (copy, nonatomic) void (^action)();

+ (id)itemWithLabel:(NSString *)inLabel image:(UIImage *)inImage action:(void(^)(void))action;

+ (id)itemWithLabel:(NSString *)inLabel imageNormal:(UIImage *)inImageNormal imageSelected:(UIImage *)inImageSelected action:(void(^)(void))action;

@end
