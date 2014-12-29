//
//  GetPhotoFromAlbumClass.h
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface GetPhotoFromAlbumClass : NSObject

+ (id)shareInstance;


#pragma mark - ALAsset的使用（一次获取所有照片或视频）
typedef void (^ DealWithPhotoOperateBlock) (NSMutableArray *);

/**
 *  一次性获取相册所有照片
 *
 *  @param library                   ALAssetsLibrary
 *  @param dealWithPhotoOperateBlock 处理获取图片后的图片处理照片动作
 */
- (void)getAllPictures:(ALAssetsLibrary *)library AndPhotoOperateBlock:(DealWithPhotoOperateBlock )dealWithPhotoOperateBlock;


@end
