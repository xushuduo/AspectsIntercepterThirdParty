//
//  JPushIntercepter.m
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/7.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "JPushIntercepter.h"
// Aspects
#import "Aspects.h"
// Config
#import "ThirdPartyConfig.h"
// AppDelegate
#import "AppDelegate.h"
// SDK
#import "JPUSHService.h"
// UserNotifications
#import <UserNotifications/UserNotifications.h>

@interface JPushIntercepter() <JPUSHRegisterDelegate>

@end

@implementation JPushIntercepter

XsdImplementSingleton

- (instancetype)init {
    self = [super init];
    if (self) {
        [AppDelegate aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSDictionary *launchOptions) {
                                  [self aop_application:application
                          didFinishLaunchingWithOptions:launchOptions
                                            appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(applicationWillEnterForeground:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application) {
                                  [self aop_applicationWillEnterForeground:application
                                                               appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(applicationDidEnterBackground:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application) {
                                  [self aop_applicationDidEnterBackground:application
                                                              appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSData *deviceToken) {
                                  [self aop_application:application
       didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
                                            appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSError *error) {
                                  [self aop_application:application
       didFailToRegisterForRemoteNotificationsWithError:error
                                            appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(application:didReceiveRemoteNotification:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSDictionary *userInfo) {
                                  [self aop_application:application
                           didReceiveRemoteNotification:userInfo
                                            appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSDictionary *userInfo, void(^completionHandler)(UIBackgroundFetchResult result)) {
                                  [self aop_application:application didReceiveRemoteNotification:userInfo appDelegate:[aspectInfo instance] fetchCompletionHandler:completionHandler];
                              }
                                   error:NULL];
    }
    return self;
}

- (BOOL)aop_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appDelegate:(AppDelegate *)appDelegate {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:kJPushChannel apsForProduction:kJPushApsForProduction advertisingIdentifier:nil];
    return YES;
}

- (void)aop_applicationWillEnterForeground:(UIApplication *)application appDelegate:(AppDelegate *)appDelegate {
    
}

- (void)aop_applicationDidEnterBackground:(UIApplication *)application appDelegate:(AppDelegate *)appDelegate  {
    
}

- (void)aop_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken appDelegate:(AppDelegate *)appDelegate {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)aop_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error appDelegate:(AppDelegate *)appDelegate {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)aop_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo appDelegate:(AppDelegate *)appDelegate {
    if (application.applicationState == UIApplicationStateActive) {
        [self showAlertWhenRecieveRemoteNotiWithUserInfo:userInfo];
    } else {
        [self handleRemoteNotiWithUserInfo:userInfo];
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)aop_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo appDelegate:(AppDelegate *)appDelegate fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateActive) {
        [self showAlertWhenRecieveRemoteNotiWithUserInfo:userInfo];
    } else {
        [self handleRemoteNotiWithUserInfo:userInfo];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleRemoteNotiWithUserInfo:userInfo];
    }
    completionHandler();
}

#pragma mark - Methods
- (void)handleRemoteNotiWithUserInfo:(NSDictionary *)userInfo {
    
}

- (void)showAlertWhenRecieveRemoteNotiWithUserInfo:(NSDictionary *)userInfo {
    
}

@end
