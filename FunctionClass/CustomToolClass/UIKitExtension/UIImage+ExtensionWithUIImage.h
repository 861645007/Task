//
//  UIImage+ExtensionWithUIImage.h
//  Task
//
//  Created by wanghuanqiang on 14/12/29.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ExtensionWithUIImage)

#pragma mark - 保存照片
/**
*  保存照片至Documents
*
*  @param imageName  图片名称
*  @param folderName 图片所放的文件夹名称(需要自带后缀)
*
*  @return YES：存放成功； NO：存放失败
*/
- (BOOL)saveImageToDocuments:(NSString *)imageName folderName:(NSString *)folderName;


/**
 *  从 Documents 的指定获取图片
 *
 *  @param imageName  图片名称
 *  @param folderName 图片所放的文件夹名称(需要自带后缀)
 *
 *  @return 返回图片 UIIamge
 */
+ (UIImage *)getImageWithImageName:(NSString *)imageName folderName:(NSString *)folderName;

@end
