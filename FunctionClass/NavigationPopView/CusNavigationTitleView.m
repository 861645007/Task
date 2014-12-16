//
//  CusNavigationTitleView.m
//  NavigationTest
//
//  Created by wanghuanqiang on 14/12/16.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "CusNavigationTitleView.h"

@implementation CusNavigationTitleView
@synthesize titleString;
@synthesize imageNameString;
@synthesize titleBtn;
@synthesize titleImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleStr imageName:(NSString *)imageNameStr {
    self = [super init];
    if (self) {
        titleString = titleStr;
        imageNameString = imageNameStr;
        [self setViewBtn];
    }
    return  self;
}

- (CGRect)setViewFrame:(CGFloat)width {
    CGRect frame = CGRectZero;
    CGRect rx = [UIScreen mainScreen].bounds;
    frame = CGRectMake((rx.size.width - width)/2, 0, width, 44);
    return frame;
}

- (void)setViewBtn {
    CGFloat viewWidth = 0;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]};
    CGFloat width = [titleString boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute  context:nil].size.width;

    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:titleString forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [titleBtn setBackgroundColor:[UIColor clearColor]];
    [titleBtn setFrame:CGRectMake(0, 0, width + 10, 44)];
    [self addSubview:titleBtn];
    viewWidth = width + 10;
    
    if (imageNameString) {
        titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameString]];
        [titleImageView setFrame:CGRectMake(titleBtn.frame.size.width + 5, (44 - 30) /2, 30, 30)];
        [self addSubview:titleImageView];
        viewWidth = viewWidth + 30 + 5;
    }
    
    self.frame = [self setViewFrame:viewWidth];
}

- (void)setTitleString:(NSString *)titleStr {
    CGFloat viewWidth = 0;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]};
    CGFloat width = [titleStr boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute  context:nil].size.width;
    
    [titleBtn setTitle:titleStr forState:UIControlStateNormal];
    [titleBtn setFrame:CGRectMake(0, 0, width + 10, 44)];
    viewWidth = width + 10;
    if (self.imageNameString) {
        viewWidth += 35;
    }
    
    self.frame = [self setViewFrame:viewWidth];
}

@end
