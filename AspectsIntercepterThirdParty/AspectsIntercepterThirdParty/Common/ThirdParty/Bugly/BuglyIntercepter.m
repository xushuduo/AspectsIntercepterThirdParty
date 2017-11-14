//
//  BuglyIntercepter.m
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/7.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "BuglyIntercepter.h"
// Aspects
#import "Aspects.h"
// Config
#import "ThirdPartyConfig.h"
// AppDelegate
#import "AppDelegate.h"
// SDK
#import "Bugly/Bugly.h"

@implementation BuglyIntercepter

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
    [Bugly startWithAppId:kBuglyAppId];
    return YES;
}

@end
