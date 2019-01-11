//
//  MyObject.m
//  oc_learn
//
//  Created by jieyueHZJ on 2019/1/10.
//  Copyright © 2019年 jieyueHZJ. All rights reserved.
//

#import "MyObject.h"

@interface MyObject()
{
    blk_t blk_;
}

@end

@implementation MyObject

- (instancetype)init {
    self = [super init];
    
    
    __block id tmp = self;
    
    blk_ = ^(id obj) {
        NSLog(@"%@", tmp);
        tmp = nil;
    };
    
    return self;
}

- (void)execBlock {
    blk_(@"");
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
