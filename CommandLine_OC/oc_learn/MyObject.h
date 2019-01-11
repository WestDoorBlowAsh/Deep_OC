//
//  MyObject.h
//  oc_learn
//
//  Created by jieyueHZJ on 2019/1/10.
//  Copyright © 2019年 jieyueHZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^blk_t)(id obj);

@interface MyObject : NSObject


- (void)execBlock;

@end

NS_ASSUME_NONNULL_END
