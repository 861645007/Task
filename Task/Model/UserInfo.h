//
//  UserInfo.h
//  ShareRoad
//
//  Created by wanghuanqiang on 14/10/31.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInToolClass.h"

@interface UserInfo : NSObject

+ (id)shareInstance;

- (void)saveUserCookie;
- (void)removeUserCookie;
- (BOOL)isCookie;

//储存用户信息
- (void)saveUserLogInName:(NSString *)userLogInName;
- (void)saveUserLogInPwd:(NSString *)userLogInPwd;

- (void)saveUserName:(NSString *)userName;
- (void)saveUserPinyinName:(NSString *)userPinyinName;
- (void)saveUserEnterpriseId:(NSString *)enterpriseId;
- (void)saveUserEnterpriseName:(NSString *)enterpriseName;
- (void)saveUserId:(NSString *)userId;
- (void)saveUserIconPath:(NSString *)userIconPath;
- (void)saveUserAttendace:(NSString *)personAttendance;

- (void)saveUserAddress:(NSString *)userAddress;
- (void)saveUserSex:(NSString *)userSex;


//获取用户信息
- (NSString *)gainUserLogInName;
- (NSString *)gainUserLogInPwd;

- (NSString *)gainUserName;
- (NSString *)gainUserPinyinName;
- (NSString *)gainUserId;
- (NSString *)gainUserEnterpriseId;
- (NSString *)gainUserEnterpriseName;
- (NSString *)gainUserIconPath;
- (NSString *)gainUserAttendance;

- (NSString *)gainUserSex;
- (NSString *)gainUserPhone;
- (NSString *)gainUserAddress;

//删除用户信息
- (void)removeUserLogInName;
- (void)removeUserLogInPwd;

- (void)removeUserName;
- (void)removeUserPinyinName;
- (void)removeUserId;
- (void)removeUserEnterpriseId;
- (void)removeUserEnterpriseName;

- (void)removeUserIconPath;
- (void)removeUserSex;
- (void)removeUserPhone;
- (void)removeUserAddress;

@end
