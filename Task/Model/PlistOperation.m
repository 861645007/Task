//
//  PlistOperation.m
//  Task
//
//  Created by wanghuanqiang on 14/12/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "PlistOperation.h"

@implementation PlistOperation

#define imageFolderName @"allPersonInfo"
#define plistName @"enterpriseAllPersonInfo.plist"

#pragma mark - 对外接口
static PlistOperation *instnce;
//使外部文件可以直接访问UesrDB内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
        
    }
    return instnce;
}

#pragma mark - 保存员工信息
- (void)saveAllPersonInfoToFile:(NSArray *)personList {    
    NSMutableArray *personInfoAfterProcessingArr = [NSMutableArray array];
    for (NSDictionary *personDic in personList) {
        [personInfoAfterProcessingArr addObject:[self dealWithData:personDic]];
    }

    
    [[CustomToolClass shareInstance] saveDataToPlist:personInfoAfterProcessingArr plistFileName:plistName folderName:imageFolderName];
}

// 处理信息
- (NSDictionary *)dealWithData:(NSDictionary *)dic {
    NSMutableDictionary *personInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[dic objectForKey:@"pinyinName"]];
    [personInfoDic setObject:imageName forKey:@"image"];
    
    [self updatePersonIcon:[dic objectForKey:@"image"] imageName:imageName];
    
    return personInfoDic;
}

// 下载图片
- (void)updatePersonIcon:(NSString *)urlString imageName:(NSString *)imageName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HttpURL, urlString]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveIcon:responseObject withFilename:imageName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}

- (void)saveIcon:(UIImage *)image withFilename:(NSString *)imageName {
    [image saveImageToDocuments:imageName folderName:imageFolderName];
}


#pragma mark - 获取员工信息
- (NSArray *)gainAllPersonInfoWithFile {
    NSArray *arr = [[CustomToolClass shareInstance] getDataFromPlist:plistName folderName:imageFolderName];
    return arr;
}

- (UIImage *)gainPersonImage:(NSString *)imageName {
    UIImage *image = [UIImage getImageWithImageName:imageName folderName:imageFolderName];
    if (image == nil) {
        return [UIImage imageNamed:@"NoSingle60"];
    }
    return image;
}

@end

