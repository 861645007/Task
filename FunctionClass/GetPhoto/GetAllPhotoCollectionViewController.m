//
//  GetAllPhotoCollectionViewController.m
//  Task
//
//  Created by wanghuanqiang on 14/12/24.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "GetAllPhotoCollectionViewController.h"

@interface GetAllPhotoCollectionViewController () {
    NSMutableArray *allPhotoList;
    NSMutableArray *isSelectedImageArr;
    
    ALAssetsLibrary *assetsLibrary;
    
    GetPhotoFromAlbumClass *getPhotoFromAlbumClass;
}

@end

@implementation GetAllPhotoCollectionViewController
@synthesize delegate;

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - initCollectionViewFlowLayout
+ (id)setCollectionViewController:(NSInteger)cellItemNum delegate:(id<SelectedPhotoProtocol>)viewDelegate {
    GetAllPhotoCollectionViewController *getPhotoController = [[GetAllPhotoCollectionViewController alloc] initWithCollectionViewLayout:[GetAllPhotoCollectionViewController setCollectionViewFlowLayout:cellItemNum]];
    getPhotoController.delegate = viewDelegate;
    return getPhotoController;
}

+ (UICollectionViewFlowLayout *)setCollectionViewFlowLayout:(NSInteger)cellNumber {
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - 5 * cellNumber * 2) / cellNumber;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(cellWidth, cellWidth)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    flowLayout.minimumLineSpacing = 5;
    
    return flowLayout;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.title = @"选择图片";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    allPhotoList = [NSMutableArray array];
    isSelectedImageArr = [NSMutableArray array];
    getPhotoFromAlbumClass = [GetPhotoFromAlbumClass shareInstance];
    
    // 设置保存按钮
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
    self.navigationItem.rightBarButtonItem = saveBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [getPhotoFromAlbumClass getAllPictures:assetsLibrary AndPhotoOperateBlock:^(NSMutableArray *photoArr){
        allPhotoList = [photoArr mutableCopy];
        
        for (int i = 0; i < [allPhotoList count]; i++) {
            [isSelectedImageArr addObject:@"0"];
        }
        
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([allPhotoList count] == 0) {
        return 0;
    }
    return [allPhotoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell * )[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    ALAsset *assetImage = [allPhotoList objectAtIndex:indexPath.row];
    if ([[isSelectedImageArr objectAtIndex:indexPath.row] intValue]) {
        cell.photoIsSelectedImageView.image = [UIImage imageNamed:@"diaryBook_SelectedImage.png"];
    }
    else{
        cell.photoIsSelectedImageView.image = [UIImage imageNamed:@"diaryBook_NoSelectedImage.png"];
    }
    
    cell.photoMainImageView.image = [UIImage imageWithCGImage:[assetImage thumbnail]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[isSelectedImageArr objectAtIndex:indexPath.row] intValue]) {
        isSelectedImageArr[indexPath.row] = @"0";
    }
    else{
        isSelectedImageArr[indexPath.row] = @"1";
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark SelectedPhotoProtocol
- (void)saveImage {
    NSMutableArray *selectedImageViewArr = [NSMutableArray array];
    
    for (int i = 0; i < [allPhotoList count] ; i++){
        if ([[isSelectedImageArr objectAtIndex:i] intValue]) {
            ALAsset *alassetImage = [allPhotoList objectAtIndex:i];
            [selectedImageViewArr addObject:[UIImage imageWithCGImage:[[alassetImage defaultRepresentation] fullScreenImage]]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedPhoto:)]) {
        [delegate selectedPhoto:selectedImageViewArr];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
