//
//  URLMacros.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

#define LBUrl(module, name) NSStringFormat(@"%@/%@", module, name)

#pragma mark - Server
#pragma mark -
/*--------------------------- server ---------------------------*/
static NSString * const LBReadImgUrl  = @"http://read.image.10039.cc/";

/** 正式环境*/
static NSString * const LBFormalServerIP    = @"http://texu.10039.cc";
/** 研发环境*/
static NSString * const LBDevelopServerIP   = @"http://texu.yf.soshare.com";
/** 测试环境*/
static NSString * const LBTestServerIP      = @"http://texu.test.soshare.com";
/** 特许合伙人端口 FXxhb */
static NSString * const LBPort = @"txhhr";

/** Weex 七牛服务器 */
static NSString * const LBWeexQiniuServerIP    = @"http://p7qgkxhyw.bkt.clouddn.com";

#define LBBasicUrl [NSString stringWithFormat:@"%@/%@", LBBaseUrl, LBPort]

/** 错误响应码 ❌ */
static NSInteger errorIntRspCode = 9999;
static NSString *errorRspCode = @"9999";
/** 错误响应信息 ❌ */
static NSString *defaultErrorMsg = @"";
static NSString *DKErrorInfoMsg = @"❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌";

#pragma mark - 当前服务器环境  =======================

#if Environment == Formal
/** 正式环境 */
#define DKDebug 0
#elif Environment == Development
/** 研发环境 */
#define DKDebug 1
#elif Environment == Test
/** 测试环境 */
#define DKDebug 0
#else
#define DKDebug 0
#endif


#if Environment == Formal
/** 正式环境 */
static NSString *LBBaseUrl   = LBFormalServerIP;
#elif Environment == Development
/** 研发环境 */
static NSString *LBBaseUrl   = LBDevelopServerIP;
#elif Environment == Test
/** 测试环境 */
static NSString *LBBaseUrl   = LBTestServerIP;
#else
static NSString *LBBaseUrl   = LBTestServerIP;
#endif


#endif /* URLMacros_h */
