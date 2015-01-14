//
//  PreviewLeaveAccessaryViewController.m
//  Task
//
//  Created by wanghuanqiang on 15/1/13.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "PreviewLeaveAccessaryViewController.h"

@interface PreviewLeaveAccessaryViewController ()

@end

@implementation PreviewLeaveAccessaryViewController
@synthesize previewImageData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *previewImage = [UIImage imageWithData:previewImageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:previewImage];
    imageView.frame = [self gainImageFrame:previewImage.size];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)gainImageFrame:(CGSize )imageSize {
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    CGFloat viewH = windowSize.height;
    CGFloat viewW = windowSize.width;
    CGRect frame;
    
    CGFloat wHRatio = imageSize.width / imageSize.height;  // 图片的长宽比
    
    if (imageSize.width > viewW && imageSize.height >  viewH - 44) {
        if (imageSize.width > imageSize.height) {
            frame = CGRectMake(0, (viewH - viewW / wHRatio) / 2, viewW, viewW / wHRatio);
        }else {
            frame = CGRectMake((viewW - viewH * wHRatio) / 2, 64, viewH * wHRatio, viewH);
        }
    }else if (imageSize.width > viewW && imageSize.height <  viewH - 44) {
        frame = CGRectMake(0, (viewH - viewW / wHRatio) / 2, viewW, viewW / wHRatio);
    }else if (imageSize.width < viewW && imageSize.height >  viewH - 44) {
        frame = CGRectMake((viewW - viewH * wHRatio) / 2, 64, viewH * wHRatio, viewH);
    }else {
        frame = CGRectMake((viewW - imageSize.width) / 2, (viewH - imageSize.height) / 2, imageSize.width, imageSize.height);
    }
    
    return frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
