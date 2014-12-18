//
//  ReadQRCodeViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/7.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ComebackValueProtocol;
@interface ReadQRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) id<ComebackValueProtocol> delegate;
@property (strong, nonatomic) AVCaptureSession *session; // 二维码生成的绘画
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;  // 二维码生成的图层


@end


@protocol ComebackValueProtocol <NSObject>

- (void)comebackValeue:(id)value;

@end