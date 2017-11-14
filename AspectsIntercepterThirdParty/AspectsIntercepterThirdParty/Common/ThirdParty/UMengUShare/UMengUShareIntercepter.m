//
//  UMengUShareIntercepter.m
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/8.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "UMengUShareIntercepter.h"
// Aspects
#import "Aspects.h"
// Config
#import "ThirdPartyConfig.h"
// AppDelegate
#import "AppDelegate.h"
// SDK
#import "UMSocialCore/UMSocialCore.h"

@implementation UMengUShareIntercepter

XsdImplementSingleton

- (instancetype)init {
    self = [super init];
    if (self) {
        [AppDelegate aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSDictionary *launchOptions) {
                                  [self aop_application:application didFinishLaunchingWithOptions:launchOptions appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
        
        [AppDelegate aspect_hookSelector:@selector(application:openURL:options:)
                             withOptions:AspectPositionBefore
                              usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *application, NSURL *url, NSDictionary<UIApplicationOpenURLOptionsKey, id> *options) {
                                  [self aop_application:application openURL:url options:options appDelegate:[aspectInfo instance]];
                              }
                                   error:NULL];
    }
    return self;
}

- (BOOL)aop_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appDelegate:(AppDelegate *)appDelegate {
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMengAppKey];
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    [self configUSharePlatforms];
    return YES;
}

- (void)configUSharePlatforms {
    // 微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppId appSecret:kWechatAppSecret redirectURL:kWechatUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:kWechatAppId appSecret:kWechatAppSecret redirectURL:kWechatUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite appKey:kWechatAppId appSecret:kWechatAppSecret redirectURL:kWechatUrl];
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppId appSecret:kQQAppKey redirectURL:kQQUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:kQQAppId appSecret:kQQAppKey redirectURL:kQQUrl];
    // 新浪微博
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAppKey appSecret:kSinaAppSecret redirectURL:kSinaUrl];
    // More: http://dev.umeng.com/sdk_integate/ios-integrate-guide/share#3_1
}

- (BOOL)aop_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options appDelegate:(AppDelegate *)appDelegate {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

@end
