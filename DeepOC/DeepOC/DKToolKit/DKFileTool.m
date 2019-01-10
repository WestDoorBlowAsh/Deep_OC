//
//  DKFileTool.m
//  DrawTrack
//
//  Created by Light on 2017/9/22.
//  Copyright © 2017年 Crane. All rights reserved.
//

#import "DKFileTool.h"
#import <CoreGraphics/CoreGraphics.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"

#if OS_OBJECT_USE_OBJC
#undef DKDispatchQueueRelease
#undef DKDispatchQueueSetterSementics
#define DKDispatchQueueRelease(q)
#define DKDispatchQueueSetterSementics strong
#else
#undef DKDispatchQueueRelease
#undef DKDispatchQueueSetterSementics
#define DKDispatchQueueRelease(q) (dispatch_release(q))
#define DKDispatchQueueSetterSementics assign
#endif

@interface DKFileTool () {
    NSFileManager *_fileManager;
}

@property (strong, nonatomic, nullable) dispatch_queue_t ioQueue;
@end

@implementation DKFileTool

+ (DKFileTool *)sharedTool {
    static DKFileTool *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

/**
 * 删除沙盒里的文件
 * @param uniquePath 文件绝对路径
 */
+ (void)deleteFileWithName:(NSString *)uniquePath {
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!isFileExist) {
        NSLog(@"File doesn't exist");
        return ;
    } else {
        NSLog(@" have");
        BOOL isDeleteFile= [fileManager removeItemAtPath:uniquePath error:nil];
        if (isDeleteFile) {
            NSLog(@"Delete file success");
        }else {
            NSLog(@"Delete file fail");
        }
    }
}

+ (NSString *)getFileInDocument:(NSString *)fileName {
    //获得文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)getFileInBundle:(NSString *)fileName type:(NSString *)type {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    return filePath;
}

// 仿照SDWebImage
- (instancetype)init {
    if (self = [super init]) {
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.crane.DKFileTool", DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DKDispatchQueueRelease(_ioQueue);
}

#pragma mark - Cache Info

- (NSString *)toMBString:(NSUInteger)size {
    CGFloat perMB = 1024 * 1024.f;
    return [NSString stringWithFormat:@"%.2lfM", size / perMB];
}

// 目录全名
- (NSString *)getMBForPath:(NSString *)fullNameDirectory {
    NSInteger size = [self getSizeForPath:fullNameDirectory];
    return [self toMBString:size];
}

// 目录全名
- (NSUInteger)getSizeForPath:(NSString *)fullNameDirectory {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [self->_fileManager enumeratorAtPath:fullNameDirectory];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [fullNameDirectory stringByAppendingPathComponent:fileName];
            size += [self getSizeForFile:filePath];
        }
    });
    return size;
}

// 文件名称
- (NSString *)getMBForFile:(NSString *)fileName {
    NSInteger size = [self getSizeForFile:fileName];
    return [self toMBString:size];
}

- (NSUInteger)getSizeForFile:(NSString *)filePath {
    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSUInteger size = [attrs fileSize];
    return size;
}

- (NSUInteger)getDiskCountForPath:(NSString *)fullNameDirectory {
    __block NSUInteger count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [self->_fileManager enumeratorAtPath:fullNameDirectory];
        count = fileEnumerator.allObjects.count;
    });
    return count;
}

- (void)calculateSizeWithPath:(NSString *)fullNameDirectory
              completionBlock:(nullable DKFileToolCalculateSizeBlock)completionBlock {
    NSURL *diskCacheURL = [NSURL fileURLWithPath:fullNameDirectory isDirectory:YES];
    
    dispatch_async(self.ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += fileSize.unsignedIntegerValue;
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}


@end

#pragma clang diagnostic pop
