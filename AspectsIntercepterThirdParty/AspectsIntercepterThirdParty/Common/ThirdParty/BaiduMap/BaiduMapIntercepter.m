//
//  BaiduMapIntercepter.m
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/8.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#import "BaiduMapIntercepter.h"
// Aspects
#import "Aspects.h"
// Config
#import "ThirdPartyConfig.h"
// AppDelegate
#import "AppDelegate.h"
// SDK
#import "BaiduMapAPI_Base/BMKMapManager.h"

@interface BaiduMapIntercepter()

@property (nonatomic, strong) BMKMapManager *manager;

@end

@implementation BaiduMapIntercepter

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
    BOOL ret = [self.manager start:kBaiduMapAppKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    return YES;
}

- (BMKMapManager *)manager {
    if (!_manager) {
        _manager = [[BMKMapManager alloc]init];
    }
    return _manager;
}

@end
