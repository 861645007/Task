//
//  AppDelegate.m
//  Task
//
//  Created by wanghuanqiang on 14/12/15.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "WorkHomeViewController.h"
#import "CusTabBarViewController.h"
#import "LogInToolClass.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [AFNetworkActivityIndicatorManager sharedManager].enabled =YES;
    
    // 制定真机调试保存日志文件
//    UIDevice *device =[UIDevice currentDevice];
//    
//    if (![[device model] isEqualToString:@"iPhone Simulator"]) {
//        [self redirectNSLogToDocumentFolder];
//    }
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];

    // 接受自定义通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 当 App 状态为未运行，这样可以获取到值
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification == nil) {
        [self saveApplicationState:0];
    }else {
        [self dealWithNotification:remoteNotification];
    }
    
    // 去除通知栏上的 推送通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

    
    return YES;
}

//- (void)redirectNSLogToDocumentFolder{
//
//    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
//    NSString *logFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveApplicationState:1];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveApplicationState:2];
}

/**
 *  保存 APP 的状态
 *
 *  @param state 0：APP 处于前台活跃状态； 1：APP 处于后台状态； 2：APP 被关闭
 */
- (void)saveApplicationState:(int)state {
    [[LogInToolClass shareInstance] saveUserInfo:[NSString stringWithFormat:@"%d", state] AndInfoType:@"ApplicationState"];
}

#pragma mark - JPush 接收通知条通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
//     处理通知数据
    [self dealWithNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
//     处理通知数据
    NSString *islocalNotification = [userInfo objectForKey:@"localNotification"];
    if (application.applicationState != UIApplicationStateInactive && ![islocalNotification isEqualToString:@"localNotification"] && islocalNotification == nil) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dic setObject:@"localNotification" forKey:@"localNotification"];
        [self createLocalNotification:dic];
    } else {
        [self dealWithNotification:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// 创建一个本地通知
- (void)createLocalNotification:(NSDictionary *)userInfo {
    UILocalNotification *localNotification = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        localNotification = [APService setLocalNotification:[NSDate date]
                              alertBody:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                  badge:-1
                            alertAction:@"打开"
                          identifierKey:@"localNotification"
                               userInfo:userInfo
                              soundName:nil
                                 region:nil
                     regionTriggersOnce:YES
                               category:nil];
    }else {
        localNotification = [APService setLocalNotification:[NSDate date]
                              alertBody:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                  badge:-1
                            alertAction:@"打开"
                          identifierKey:@"localNotification"
                               userInfo:userInfo
                              soundName:nil];
    }
    [APService showLocalNotificationAtFront:localNotification identifierKey:@"localNotification"];
}

// 处理自定义通知
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self dealWithNotification:userInfo];
}

- (void)dealWithNotification:(NSDictionary *)notificationDic {
    
    NSMutableDictionary *notificationInfo = [self gainNotificationInfo:notificationDic];
    [notificationInfo setObject:[[LogInToolClass shareInstance] getUserInfo:@"ApplicationState"] forKey:@"ApplicationState"];
    
    // 设置完 通知后，将 APP 状态设置为 在前台
    [self saveApplicationState:0];
    [self performSelector:@selector(sendNotification:) withObject:notificationInfo afterDelay:0.5];

    // 去除 badge
    [APService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

- (void)sendNotification:(NSDictionary *)dic {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"systemNotification" object:dic];
}

- (NSMutableDictionary *)gainNotificationInfo:(NSDictionary *)dic {
    NSString *cmdStr = [dic objectForKey:@"cmd"];
    NSMutableDictionary *notificationInfo = [NSMutableDictionary dictionary];
    
    switch ([cmdStr intValue]) {
        case 1:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"iosVersionCode"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"-1"] forKey:@"badgePage"];
            break;
        case 2:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticeId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"0"] forKey:@"badgePage"];
            break;
        case 3:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"2"] forKey:@"badgePage"];
            break;
        case 4:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"2"] forKey:@"badgePage"];
            break;
        case 5:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"2"] forKey:@"badgePage"];
            break;
        case 6:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"2"] forKey:@"badgePage"];
            break;
        case 7:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"2"] forKey:@"badgePage"];
            break;
        case 8:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"leaveId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"3"] forKey:@"badgePage"];
            break;
        case 9:
            [notificationInfo setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"leaveId"]] forKey:@"notificationInfoStr"];
            [notificationInfo setObject:[NSString stringWithFormat:@"4"] forKey:@"badgePage"];
            break;
        default:
            break;
    }
    
    return notificationInfo;
}

@end
