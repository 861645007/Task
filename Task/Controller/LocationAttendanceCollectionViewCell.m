//
//  LocationAttendanceCollectionViewCell.m
//  Task
//
//  Created by wanghuanqiang on 15/3/10.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "LocationAttendanceCollectionViewCell.h"

@implementation LocationAttendanceCollectionViewCell
@synthesize selectedImageView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat width = (size.width - 16 - 10*3) / 4;
        self.selectedImageView.frame = CGRectMake(0, 0, width, width);
    }
    
    return self;
}


@end
