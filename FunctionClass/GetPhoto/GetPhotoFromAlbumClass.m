//
//  GetPhotoFromAlbumClass.m
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "GetPhotoFromAlbumClass.h"


@implementation GetPhotoFromAlbumClass


#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
static GetPhotoFromAlbumClass *instnce;

+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

#pragma mark - ALAsset的使用（一次获取所有照片或视频）

-(void)getAllPictures:(ALAssetsLibrary *)library AndPhotoOperateBlock:(DealWithPhotoOperateBlock )dealWithPhotoOperateBlock{
    __block NSInteger count = 0;
    NSMutableArray *imageOfAlAssetArr = [NSMutableArray array];
    
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                //获取了路径
                NSURL *url= (NSURL*) [[result defaultRepresentation] url];
                //根据路径重新获取了每一个照片的 asset
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             if (asset != nil ) {
                                 [imageOfAlAssetArr addObject:asset];
                                 if ([imageOfAlAssetArr count] == count) {
                                     //处理照片操作
                                     dealWithPhotoOperateBlock(imageOfAlAssetArr);
                                 }
                             }else {
                                 dealWithPhotoOperateBlock(imageOfAlAssetArr);
                             }
                         }
                        failureBlock:^(NSError *error){
                            NSLog(@"operation was not successfull!");
                        }];
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count += [group numberOfAssets];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {
                             NSLog(@"There is an error");
                         }];
}


@end
