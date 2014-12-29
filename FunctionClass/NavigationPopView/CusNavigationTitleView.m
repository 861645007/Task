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
@synthesize selectRowAtIndex;
@synthesize titleStrArr;
@synthesize titleLabel;
@synthesize titleImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleStr titleStrArr:(NSMutableArray *)titleArr imageName:(NSString *)imageNameStr {
    self = [super init];
    if (self) {
        titleString = titleStr;
        imageNameString = imageNameStr;
        titleStrArr = titleArr;
        [self setViewControls];
    }
    return  self;
}

- (CGRect)setViewFrame:(CGFloat)width {
    CGRect frame = CGRectZero;
    CGRect rx = [UIScreen mainScreen].bounds;
    frame = CGRectMake((rx.size.width - width)/2, 0, width, 44);
    return frame;
}

- (CGFloat)gainTextWidth {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]};
    CGFloat width = [titleString boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute  context:nil].size.width;
    
    return width;
}

// 设置控件
- (void)setViewControls {
    CGFloat viewWidth = 0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self gainTextWidth] + 10, 44)];
    titleLabel.text = titleString;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    viewWidth = titleLabel.frame.size.width + 5;
    
    if (imageNameString) {
        titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameString]];
        [titleImageView setFrame:CGRectMake(titleLabel.frame.size.width, (44 - 25) /2, 25, 25)];
        [self addSubview:titleImageView];
        viewWidth = viewWidth + 25;
    }
    
    self.frame = [self setViewFrame:viewWidth];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItemNav:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

// 设置弹出框
- (void)selectItemNav:(UIButton *)sender {
    CGRect rx = [UIScreen mainScreen].bounds;
    CGPoint point = CGPointMake(rx.size.width/ 2, self.frame.origin.y + self.frame.size.height);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titleStrArr images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        self.selectRowAtIndex(index);
    };
    [pop show];
}

- (void)setTitleString:(NSString *)titleStr {
    CGFloat viewWidth = 0;
    titleString = titleStr;
    titleLabel.text = titleStr;
    [titleLabel setFrame:CGRectMake(0, 0, [self gainTextWidth] + 10, 44)];
    viewWidth = titleLabel.frame.size.width + 10;
    if (self.imageNameString) {
        [titleImageView setFrame:CGRectMake(titleLabel.frame.size.width, (44 - 25) /2, 25, 25)];
        viewWidth = viewWidth + 25;
    }
    
    self.frame = [self setViewFrame:viewWidth];
}

@end
