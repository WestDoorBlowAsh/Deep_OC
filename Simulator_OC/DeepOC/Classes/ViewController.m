//
//  ViewController.m
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import "ViewController.h"
#import "DKNetworkManager.h"

#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = kRandomColor;
    
    
    BOOL isTest = YES;
    
    NSInteger i = 0;
    
    NSInteger j = i ?: 333;
    
    NSLog(@"j = %zd", j);
    
}

- (void)AFNetworkingStudy {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置自定义解析方式
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        return @"";
    }];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", LBBasicUrl, LBUrl(@"treasure", @"qryTops")];
    NSDictionary *params =
    @{
      @"current": @"1",
      @"size": @"10",
      };
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)YTKNetworkStudy {
    NSDictionary *params =
    @{
      @"current": @"1",
      @"size": @"10",
      };
    
    [DKNetworkManager configNetwork];
    [DKNetworkManager POST:LBUrl(@"treasure", @"qryTops") params:params readCache:YES completion:^{
        NSLog(@"sss");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
