//
//  ThirdPartyConfig.h
//  AspectsIntercepterThirdParty
//
//  Created by XSDCoder on 2017/11/7.
//  Copyright © 2017年 XSDCoder. All rights reserved.
//

#ifndef ThirdPartyConfig_h
#define ThirdPartyConfig_h

// 极光推送配置
// Docs: https://docs.jiguang.cn/jpush/client/iOS/ios_sdk/
/** 极光推送AppKey */
static NSString * const kJPushAppKey = @"";
/** 极光推送渠道 */
static NSString * const kJPushChannel = @"App Store";
/** 极光推送APNs证书环境 */
static const NSInteger kJPushApsForProduction = 0;

// 友盟配置
// Docs: http://dev.umeng.com/sdk_integate/ios-integrate-guide/common
/** 友盟AppKey */
static NSString * const kUMengAppKey = @"";
/** 友盟渠道 */
static NSString * const kUMengChannel = @"App Store";

// 分享第三方SDK配置
// 微信开放平台: https://open.weixin.qq.com/
// QQ开放平台: http://open.qq.com/
// 新浪微博开放平台: http://open.weibo.com/
/** 微信AppId */
static NSString * const kWechatAppId = @"";
/** 微信AppSecret */
static NSString * const kWechatAppSecret = @"";
/** 微信分享回调Url */
static NSString * const kWechatUrl = @"http://mobile.umeng.com/social";
/** QQAppId */
static NSString * const kQQAppId = @"";
/** QQAppKey */
static NSString * const kQQAppKey = @"";
/** QQ分享回调Url */
static NSString * const kQQUrl = @"http://mobile.umeng.com/social";
/** 新浪微博AppId */
static NSString * const kSinaAppKey = @"";
/** 新浪微博AppKey */
static NSString * const kSinaAppSecret = @"";
/** 新浪微博分享回调Url */
static NSString * const kSinaUrl = @"https://sns.whalecloud.com/sina2/callback";

// Bugly配置
// Docs: https://bugly.qq.com/docs/user-guide/instruction-manual-ios/
/** BuglyAppId */
static NSString * const kBuglyAppId = @"";

// 蒲公英配置
// Docs: https://www.pgyer.com/doc/view/sdk_ios_guide
/** 蒲公英AppId */
static NSString * const kPgyerAppId = @"";

// 高德地图配置
// Docs: http://lbs.amap.com/api
/** 高德地图AppKey */
static NSString * const kAmapAppKey = @"";

// 百度地图配置
// Docs: http://lbsyun.baidu.com/index.php?title=iossdk
/** 百度地图AppKey */
static NSString * const kBaiduMapAppKey = @"";

// 单例
#define XsdImplementSingleton \
+ (instancetype)sharedManager { \
    static dispatch_once_t once; \
    static id instance; \
    dispatch_once(&once, ^{ \
        instance = [self new]; \
    }); \
    return instance; \
} \
+ (void)load { \
    [super load]; \
    [self sharedManager]; \
}

#endif /* ThirdPartyConfig_h */
