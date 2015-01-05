//
//  GetAllPhotoCollectionViewController.h
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCollectionViewCell.h"
#import "GetPhotoFromAlbumClass.h"

@protocol SelectedPhotoProtocol <NSObject>

/**
 *  选择的照片协议
 *
 *  @param imageList 返回选择的照片的列表（UIImage）
 */
- (void)selectedPhoto:(NSArray *)imageList;

@end

@interface GetAllPhotoCollectionViewController : UICollectionViewController

@property (nonatomic, strong) id<SelectedPhotoProtocol> delegate;

+ (UICollectionViewFlowLayout *)setCollectionViewFlowLayout:(NSInteger)cellNumber;
+ (id)setCollectionViewController:(NSInteger)cellItemNum delegate:(id<SelectedPhotoProtocol>)viewDelegate;

@end
