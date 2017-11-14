//
//  PgyerIntercepter.m
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/7.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "PgyerIntercepter.h"
// Aspects
#import "Aspects.h"
// Config
#import "ThirdPartyConfig.h"
// AppDelegate
#import "AppDelegate.h"
// SDK
#import "PgySDK/PgyManager.h"
#import "PgyUpdate/PgyUpdateManager.h"

@implementation PgyerIntercepter

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
    }
    return self;
}

- (BOOL)aop_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appDelegate:(AppDelegate *)appDelegate {
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
    return YES;
}

@end
