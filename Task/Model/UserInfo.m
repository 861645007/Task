//
//  UserInfo.m
//  ShareRoad
//
//  Created by wanghuanqiang on 14/10/31.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *instnce;
#pragma mark - 对外接口
//使外部文件可以直接访问UesrDB内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

- (void)saveUserCookie {
    [[LogInToolClass shareInstance] saveCookie:YES];
}

- (void)removeUserCookie {
    [[LogInToolClass shareInstance] saveCookie:NO];
}

- (BOOL)isCookie {
    return [[LogInToolClass shareInstance] isCookie];
}

//储存用户信息

// 登陆时的用户信息
- (void)saveUserLogInName:(NSString *)userLogInName{
    [[LogInToolClass shareInstance] saveUserInfo:userLogInName AndInfoType:@"userLogInName"];
}

- (void)saveUserLogInPwd:(NSString *)userLogInPwd {
    [[LogInToolClass shareInstance] saveUserInfo:userLogInPwd AndInfoType:@"userLogInPwd"];
}

// 基本用户信息
- (void)saveUserName:(NSString *)userName {
    [[LogInToolClass shareInstance] saveUserInfo:userName AndInfoType:@"personName"];
}
- (void)saveUserEnterpriseId:(NSString *)enterpriseId {
    [[LogInToolClass shareInstance] saveUserInfo:enterpriseId AndInfoType:@"personEnterpriseId"];
}
- (void)saveUserEnterpriseName:(NSString *)enterpriseName {
    [[LogInToolClass shareInstance] saveUserInfo:enterpriseName AndInfoType:@"personEnterpriseName"];
}
- (void)saveUserId:(NSString *)userId {
    [[LogInToolClass shareInstance] saveUserInfo:userId AndInfoType:@"personId"];
}

- (void)saveUserAddress:(NSString *)userAddress {
    [[LogInToolClass shareInstance] saveUserInfo:userAddress AndInfoType:@"personAddress"];
}
- (void)saveUserSex:(NSString *)userSex {
    [[LogInToolClass shareInstance] saveUserInfo:userSex AndInfoType:@"personSex"];
}
- (void)saveUserPhone:(NSString *)userPhone {
    [[LogInToolClass shareInstance] saveUserInfo:userPhone AndInfoType:@"personPhone"];
}
//- (void)saveUserIcon:(NSData *)userIcon {
//    [[PhotoAndCameraClass shareInstance] saveImageToDocuments:userIcon AndImageName:@"userImageIcon.png"];
//}
//- (void)saveUserIconPath {
//    [[LogInToolClass shareInstance] saveUserInfo:[[PhotoAndCameraClass shareInstance] getImageURLString:@"userImageIcon.png"] AndInfoType:@"personIcon"];
//}

//获取用户信息
- (NSString *)gainUserLogInName {
    return [[LogInToolClass shareInstance] getUserInfo:@"userLogInName"];
}
- (NSString *)gainUserLogInPwd {
    return [[LogInToolClass shareInstance] getUserInfo:@"userLogInPwd"];
}


- (NSString *)gainUserName {
    return [[LogInToolClass shareInstance] getUserInfo:@"personName"];
}

- (NSString *)gainUserId {
    return [[LogInToolClass shareInstance] getUserInfo:@"personId"];
}
- (NSString *)gainUserEnterpriseId {
    return [[LogInToolClass shareInstance] getUserInfo:@"personEnterpriseId"];
}
- (NSString *)gainUserEnterpriseName {
    return [[LogInToolClass shareInstance] getUserInfo:@"personEnterpriseName"];
}


- (NSString *)gainUserIconPath {
    return [[LogInToolClass shareInstance] getUserInfo:@"personIcon"];
}
//- (NSDictionary *)gainUserIcon {
//    return [[PhotoAndCameraClass shareInstance] getImageWithImageName:@"userImageIcon"];
//}
- (NSString *)gainUserSex {
    return [[LogInToolClass shareInstance] getUserInfo:@"personSex"];
}
- (NSString *)gainUserPhone {
    return [[LogInToolClass shareInstance] getUserInfo:@"personPhone"];
}
- (NSString *)gainUserAddress {
    return [[LogInToolClass shareInstance] getUserInfo:@"personAddress"];
}


//删除用户信息
- (void)removeUserLogInName {
    [[LogInToolClass shareInstance] removeUserInfo:@"userLogInName"];
}

- (void)removeUserLogInPwd {
    [[LogInToolClass shareInstance] removeUserInfo:@"userLogInPwd"];
}

- (void)removeUserName {
    [[LogInToolClass shareInstance] removeUserInfo:@"personName"];
}

- (void)removeUserId {
    [[LogInToolClass shareInstance] removeUserInfo:@"personId"];
}
- (void)removeUserEnterpriseId {
    [[LogInToolClass shareInstance] removeUserInfo:@"personEnterpriseId"];
}
- (void)removeUserEnterpriseName {
    [[LogInToolClass shareInstance] removeUserInfo:@"personEnterpriseName"];
}


- (void)removeUserIcon {
    [[LogInToolClass shareInstance] removeUserInfo:@"personIcon"];
}
- (void)removeUserSex {
    [[LogInToolClass shareInstance] removeUserInfo:@"personPhone"];
}
- (void)removeUserPhone{
    [[LogInToolClass shareInstance] removeUserInfo:@"personPhone"];
}
- (void)removeUserAddress {
    [[LogInToolClass shareInstance] removeUserInfo:@"personAddress"];
}


@end
