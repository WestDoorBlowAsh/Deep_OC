//
//  Block.m
//  oc_learn
//
//  Created by jieyueHZJ on 2019/1/9.
//  Copyright © 2019年 jieyueHZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyObject.h"


/**
  *  clang -rewrite-objc main.m
  *
 */


void testUnsafe_unretained() {
    //        id __weak obj1 = nil;
    id __unsafe_unretained obj1 = nil;
    
    {
        id __strong obj0 = [[NSObject alloc] init];
        
        obj1 = obj0;
        
        NSLog(@"obj1 = %@", obj1);
        
        //            obj1 = nil;
    }
    
    NSLog(@"obj1 = %@", obj1);
}

void testBlock() {
    int dy = 222;
    
    void (^blk)(void) = ^{
        NSLog(@"%d", dy);
    };
    
    dy = 33;
    blk();
}


void compileBlock() {
    void (^blk)(void) = ^{
        printf("hahahaha\n");
    };
    blk();
}



void copyBlock() {
    
    blk_t blk;
    
    {
        id array = [[NSMutableArray alloc] init];
        
//        id __weak array = array1;
        
        NSLog(@"==== %p", array);
        blk = ^(id obj) {
            [array addObject:obj];
            NSLog(@"%p %zd", array, [array count]);
        };
    }
    
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}

void myObjectBlock() {

    id o = [[MyObject alloc] init];
    
    [o execBlock];
    
    NSLog(@"===== %@", o);
}

void testSemaphore1() {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
    
    long result = dispatch_semaphore_wait(semaphore, time);
//    long result = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (result == 0) {
        
        /*
         * 由于 semaphore 计数值达到 大于等于 1
         * 或者 在待机中指定的时间内
         * semaphore 的计数值达到 大于等于 1
         * 所以 semaphore 的计数值 减去 1
         *
         * 可以执行需要进行排他控制的处理
         *
         * 处理结束时通过 dispatch_semaphore_signal 函数将 semaphore 的计数值加 1
         */
        
        NSLog(@"执行任务...");
        NSLog(@"执行任务结束");
        
        dispatch_semaphore_signal(semaphore);
        
    } else {
        /*
         * 由于 semaphore 的计数值为 0
         * 因此在达到指定时间为止待机
         */
        NSLog(@"show toast");
    }

}



void testSemaphore() {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSLog(@"主线程: %@", [NSThread mainThread]);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; i++) {
        
        NSLog(@"循环 %zd 开始", i);
        
        
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            NSLog(@"index: %zd 当前线程: %@ semaphore = %@", i, [NSThread currentThread], semaphore);
            
            [array addObject:[NSNumber numberWithInteger:i]];
            
            dispatch_semaphore_signal(semaphore);
            
        });
    }
    
//    while (array.count != 10) {
//        // 死循环
//    }
    
    if (array.count == 10) {
        NSLog(@"okokokokokokokokokokokokokokokokokokokokok");
    }

}

void testDispatchData() {
    
    
}


int main(int argc, const char * argv[]) {
    
//    compileBlock();
    
//    copyBlock();
    
//    myObjectBlock();
   
//    testSemaphore();

    
    
    return 0;
}


