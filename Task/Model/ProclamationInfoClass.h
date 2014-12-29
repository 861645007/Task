//
//  ProclamationInfoClass.h
//  Task
//
//  Created by wanghuanqiang on 14/12/19.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProclamationInfoClass : NSObject

@property (nonatomic, strong) NSString *proclamationNoticeId;
@property (nonatomic, strong) NSString *proclamationUserId;
@property (nonatomic, strong) NSString *proclamationRealName;
@property (nonatomic, strong) NSString *proclamationCreateTime;
@property (nonatomic, strong) NSString *proclamationContent;
@property (nonatomic, strong) NSString *proclamationCheckCount;
@property (nonatomic, strong) NSString *proclamationIsCheck;
@property (nonatomic, strong) NSString *proclamationNoticeUsers;
@property (nonatomic, strong) NSArray  *proclamationNoticeUsersList;
@property (nonatomic, strong) NSArray  *proclamationCommentsList;


@end
