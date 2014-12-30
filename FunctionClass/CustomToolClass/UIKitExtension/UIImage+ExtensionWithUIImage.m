//
//  UIImage+ExtensionWithUIImage.m
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "UIImage+ExtensionWithUIImage.h"

@implementation UIImage (ExtensionWithUIImage)


#pragma mark - 保存照片到documents

//保存单张照片到documents,返回文件名
- (BOOL)saveImageToDocuments:(NSString *)imageName folderName:(NSString *)folderName {
    //这里将图片放在沙盒的documents文件夹中
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    if (![folderName isEqualToString:@""] || folderName != nil) {
        documentsPath = [documentsPath stringByAppendingFormat:@"/%@", folderName];
    }
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 存文件
    BOOL result = [fileManager createFileAtPath:[documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]] contents:UIImageJPEGRepresentation(self, 1.0) attributes:nil];
    
    return result;
}

+ (UIImage *)getImageWithImageName:(NSString *)imageName folderName:(NSString *)folderName {
    //这里将图片放在沙盒的documents文件夹中
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    if (![folderName isEqualToString:@""] || folderName != nil) {
        documentsPath = [documentsPath stringByAppendingFormat:@"/%@", folderName];
    }
    
    //得到选择后沙盒中图片的完整路径
    NSString *imagePath = [[NSString alloc]initWithFormat:@"%@%@",documentsPath,  [NSString stringWithFormat:@"/%@",imageName]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

@end
