//
//  DKNetworkManager.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKRequest;

typedef DKRequest *(^BuildRequest)(DKRequest *req);

@interface DKNetworkManager : NSObject

+ (void)POST:(NSString *)path
      params:(NSDictionary *)params
   readCache:(BOOL)isReadCache
  completion:(dispatch_block_t)completion;

+ (void)configNetwork;

@end
