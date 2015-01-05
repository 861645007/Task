//
//  PhotoCollectionViewCell.m
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
@synthesize photoIsSelectedImageView;
@synthesize photoMainImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self SetPhotoView:frame];
//        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)SetPhotoView:(CGRect)frame {
    // 设置 图片
    photoMainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.contentView addSubview:photoMainImageView];
    
    // 设置 isSelected 图片
    photoIsSelectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 27, 3, 25, 25)];
    [self.contentView addSubview:photoIsSelectedImageView];
}

@end
