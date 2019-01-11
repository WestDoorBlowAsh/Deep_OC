//
//  DKRequest.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import "YTKRequest.h"

@class DKRequest, DKResponse;

typedef void(^DKResponseCompletion)(__kindof DKRequest *request, DKResponse *response);

@interface DKRequest : YTKRequest

@property (nonatomic, assign) BOOL isReadCache;

- (instancetype)initGetWithPath:(NSString *)path
                         params:(NSDictionary *)params;

- (instancetype)initPostWithPath:(NSString *)path
                          params:(NSDictionary *)params;

- (void)startWithSuccess:(DKResponseCompletion)success
                 failure:(DKResponseCompletion)failure;


@end

@interface DKResponse : NSObject

#pragma mark - Base Reponse
@property (nonatomic, strong) id data;
@property (nonatomic, strong) id result;
@property (nonatomic, copy) NSString *params;

// 合伙人
@property (nonatomic, copy) NSString *rspCode;
@property (nonatomic, copy) NSString *rspMsg;
@property (nonatomic, copy) NSString *errorCode;

@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *returnCode;

#pragma mark - data的具体类型

@property (nonatomic, strong) NSArray *returnArray;
@property (nonatomic, strong) NSString *returnString;
@property (nonatomic, strong) NSNumber *returnNumber;
@property (nonatomic, strong) NSDictionary *returnDictionary;

@property (nonatomic, strong) NSString *returnJSONString;
@property (nonatomic, strong) NSString *returnJSONObject;

@property (nonatomic, assign) BOOL isErrorData;

+ (DKResponse *)errorResponse;

+ (__kindof DKResponse *)modelWithRequest:(DKRequest *)request;

@end
