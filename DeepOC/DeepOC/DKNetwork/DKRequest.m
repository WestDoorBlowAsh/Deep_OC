//
//  DKRequest.m
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import "DKRequest.h"

#import "URLMacros.h"
#import "DKTimeTool.h"


void DKDebugLog(NSString *format, ...) {
#ifdef DEBUG
//    if (![DKDebugManager sharedDKDebugManager].debugLogEnabled) {
//        return;
//    }
    format = [NSString stringWithFormat:@"\n📍\n%@\n\n",format];
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@interface DKRequest ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) YTKRequestMethod method;

@property (nonatomic, copy) NSString *port;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, copy) NSString *methodString;

// 开始时间
@property (nonatomic, strong) NSString *startDate;

// 结束时间
@property (nonatomic, strong) NSString *endDate;

@end

@implementation DKRequest

static NSInteger cacheTime = 150;

- (instancetype)initWithMethod:(YTKRequestMethod)method
                          path:(NSString *)path
                        params:(NSDictionary *)params{
    if (self = [super init]) {
        _method = method;
        _path = path;
        _params = params;
    }
    return self;
}

#pragma mark - Build Request
#pragma mark -

- (instancetype)initGetWithPath:(NSString *)path
                         params:(NSDictionary *)params {
    self = [self initWithMethod:YTKRequestMethodGET path:path params:params];
    return self;
}

- (instancetype)initPostWithPath:(NSString *)path
                          params:(NSDictionary *)params {
    self = [self initWithMethod:YTKRequestMethodPOST path:path params:params];
    return self;
}

- (NSInteger)cacheTimeInSeconds {
    if (self.isReadCache) {
        return cacheTime;
    }
    return [super cacheTimeInSeconds];
}

- (id)requestArgument {
    return _params;
}

- (NSString *)requestUrl {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", self.port, self.path];
    return requestUrl;
}

- (YTKRequestMethod)requestMethod {
    return _method;
}

- (NSString *)port {
    return LBPort;
}

#pragma mark - Method

// 超时时间
#if Environment != Formal
- (double)requestTimeoutInterval {
    return 15;
}
#endif

- (NSString *)methodString {
    switch (self.requestMethod) {
        case YTKRequestMethodGET:
            return @"GET";
            break;
        case YTKRequestMethodPOST:
            return @"POST";
            break;
        case YTKRequestMethodHEAD:
            return @"HEAD";
            break;
        case YTKRequestMethodPUT:
            return @"PUT";
            break;
        case YTKRequestMethodDELETE:
            return @"DELETE";
            break;
        case YTKRequestMethodPATCH:
            return @"PATCH";
            break;
        default:
            return @"Unknown";
            break;
    }
    return @"Unknown";
}

- (NSString *)getDataLength {
    return self.currentRequest.allHTTPHeaderFields[@"Content-Length"];
}

#pragma mark - Send Req

- (void)startWithSuccess:(DKResponseCompletion)success
                 failure:(DKResponseCompletion)failure {
    
    DKDebugLog(@"发起请求:%@\n参数:%@", self.requestUrl, self.params);
    
    self.startDate = [DKTimeTool dateStringWithDate:[NSDate date]];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof DKRequest * _Nonnull request) {
        [self requestSuccess:success failure:failure request:request];
    } failure:^(__kindof DKRequest * _Nonnull request) {
        [self requestFailure:failure request:request];
    }];
}

// 请求成功
- (void)requestSuccess:(DKResponseCompletion)success
               failure:(DKResponseCompletion)failure
               request:(DKRequest * _Nonnull )request {
    
    request.endDate = [DKTimeTool dateStringWithDate:[NSDate date]];
    DKResponse *response = [DKResponse modelWithRequest:request];
    if (response.isErrorData) {
        BLOCK_EXEC(failure, request, response);
    } else {
        BLOCK_EXEC(success, request, response);
    }
}

// 请求失败
- (void)requestFailure:(DKResponseCompletion)failure
               request:(DKRequest * _Nonnull )request {
    
    request.endDate = [DKTimeTool dateStringWithDate:[NSDate date]];
    
    DKResponse *errorResp = [DKResponse errorResponse];
    [DKRequest logRequest:request msg:errorResp.returnMessage];
    BLOCK_EXEC(failure, request, errorResp);
}

#pragma mark - Debug Req

+ (void)logRequest:(DKRequest *)request msg:(NSString *)message {
    DKDebugLog(@"%@ %@\nurl: %@\n参数: %@\n完整url:\n%@\nresponseObj: %@", request.methodString, message, request.currentRequest.URL.absoluteString, request.params, request.netParamString, request.responseJSONObject);
    
    /*
     NSString *method = request.methodString;
     //    NSString *absoluteURLString = request.currentRequest.URL.absoluteString;
     NSDictionary *paramDic = request.params;
     NSString *paramJson = request.params.jsonStringEncoded;
     NSString *absoluteURLString = request.netParamString;
     NSObject *responseObj = request.responseJSONObject;
     //    NSString *responseJson = request.responseString;
     
     //    NSLog(@"%@ %@\nurl: %@\n参数: %@\n完整url:\n%@\nresponseObj: %@", method, message, absoluteURLString, paramDic, paramJson, responseObj);
     
     NSLog(@"%@ %@\n完整url: %@\nurl:%@\nparamsJSON:\n%@\n", method, message, absoluteURLString, request.requestUrl, paramJson);
     //    NSLog(@"returnJSONString:\n%@", responseJson);
     */
}

- (NSString *)netParamString {
    NSMutableString *allParams = [NSMutableString stringWithFormat:@"%@?", self.currentRequest.URL.absoluteString];
    [self.params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [allParams appendFormat:@"%@=%@&", key, obj];
    }];
    return [allParams substringToIndex:allParams.length - 1];
}

@end

#pragma mark - Base Response
#pragma mark -

@interface DKResponse ()

@property (nonatomic, copy) NSString *respCode;
@property (nonatomic, copy) NSString *respDesc;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *status;


@end

@implementation DKResponse

+ (__kindof DKResponse *)modelWithRequest:(DKRequest *)request {
    DKResponse *response = [[self class] yy_modelWithJSON:request.responseString];
    response.returnJSONString = request.responseString;
    response.returnJSONObject = request.responseObject;
    return response;
}

- (void)setReturnProperty:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.returnString = data;
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        self.returnDictionary = data;
    } else if ([data isKindOfClass:[NSArray class]]) {
        self.returnArray = data;
    } else if ([data isKindOfClass:[NSNumber class]]) {
        self.returnNumber = data;
    } else if (!data || [data isKindOfClass:[NSNull class]]){
        NSLog(@"response data or result is null");
        self.isErrorData = YES;
    } else {
        NSLog(@"❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌");
        self.isErrorData = YES;
    }
}

- (void)setData:(id)data {
    _data = data;
    
    [self setReturnProperty:data];
}

- (void)setResult:(id)result {
    _result = result;
    
    [self setReturnProperty:result];
}

+ (DKResponse *)errorResponse {
    DKResponse *response = [DKResponse new];
    response.returnMessage = @"请求失败";
    response.isErrorData = YES;
    return response;
}

- (NSString *)returnMessage {
    if (!_returnMessage) {
        NSString *returnMessage = nil;
        if (self.rspMsg.length > 0) {
            returnMessage = self.rspMsg;
        } else if (self.respDesc.length > 0) {
            returnMessage = self.respDesc;
        } else if (self.msg.length > 0) {
            returnMessage = self.msg;
        }
        _returnMessage = returnMessage;
    }
    return _returnMessage;
}

- (NSString *)returnCode {
    NSString *responseCode = nil;
    if (self.rspCode.length > 0) {
        responseCode = self.rspCode;
    } else if (self.respCode.length > 0) {
        responseCode = self.respCode;
    } else if (self.status.length > 0) {
        responseCode = self.status;
    }
    if (responseCode.length == 0 && self.params) {
        // 这个是 u_BankList 的接口
        responseCode = @"0000";
    }
    _returnCode = responseCode;
    return _returnCode;
}

@end
