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

- (void)selectedPhoto:(NSArray *)imageList;

@end

@interface GetAllPhotoCollectionViewController : UICollectionViewController

@property (nonatomic, strong) id<SelectedPhotoProtocol> delegate;

@end
