//
//  AppDelegate.m
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/6.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import "AppDelegate.h"
#import "YCCurrentPlanController.h"
#import <CoreData/CoreData.h>

@interface AppDelegate () {
    UITabBarController *_rootTabController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _rootTabController = [[UITabBarController alloc] init];
    self.window.rootViewController = _rootTabController;
    [_rootTabController.tabBar setBackgroundColor:[UIColor grayColor]];
    
    YCCurrentPlanController *current = [[YCCurrentPlanController alloc] init];
    [current.tabBarItem setTitle:@"当前计划"];
    current.type = Current;
    UINavigationController *currentNav = [[UINavigationController alloc] initWithRootViewController:current];
    current.title = @"当前计划";
    [_rootTabController addChildViewController:currentNav];
    
    YCCurrentPlanController *willDo = [[YCCurrentPlanController alloc] init];
    [willDo.tabBarItem setTitle:@"未来计划"];
    willDo.type = Will;
    UINavigationController *willDoNav = [[UINavigationController alloc] initWithRootViewController:willDo];
    [_rootTabController addChildViewController:willDoNav];
    willDo.title = @"未来计划";
    
    YCCurrentPlanController *donePlan = [[YCCurrentPlanController alloc] init];
    [donePlan.tabBarItem setTitle:@"过去计划"];
    donePlan.type = Done;
    UINavigationController *donePlanNav = [[UINavigationController alloc] initWithRootViewController:donePlan];
    [_rootTabController addChildViewController:donePlanNav];
    donePlan.title = @"过去计划";
    
    
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }else {
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}

- (void)addLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *nowDate = [formatter dateFromString:@"18:30"];
    notification.fireDate = nowDate;
    notification.repeatInterval = kCFCalendarUnitDay;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = @"今天你的计划完成了吗";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
