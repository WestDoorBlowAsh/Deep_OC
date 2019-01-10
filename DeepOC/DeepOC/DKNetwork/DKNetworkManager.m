//
//  DKNetworkManager.m
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import "DKNetworkManager.h"
#import "DKRequest.h"

#import <YTKNetwork.h>
//#import <AFNetworking.h>

@implementation DKNetworkManager

+ (void)configNetwork {
    /** 配置 YTKNetworkConfig */
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = LBBaseUrl;
    config.cdnUrl = LBReadImgUrl;
    config.debugLogEnabled = YES;
    
    //    config.debugLogEnabled = NO;
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>\nBaseUrl:%@\n>>>>>>>>>>>>>>>>>>>>>>", LBBaseUrl);
    
    /** 配置 网络监控 */
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)POST:(NSString *)path
      params:(NSDictionary *)params
   readCache:(BOOL)isReadCache
  completion:(dispatch_block_t)completion {
    
    DKRequest *req = [[DKRequest alloc] initPostWithPath:path params:params];
    req.isReadCache = isReadCache;
    [req startWithSuccess:^(__kindof DKRequest *request, DKResponse *response) {
        NSLog(@"success = %@", response.returnJSONString);
    } failure:^(__kindof DKRequest *request, DKResponse *response) {
        NSLog(@"failure = %@", response.data);
    }];
}

@end
