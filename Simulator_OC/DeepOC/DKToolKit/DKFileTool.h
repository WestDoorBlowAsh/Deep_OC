//
//  DKFileTool.h
//  DrawTrack
//
//  Created by Light on 2017/9/22.
//  Copyright © 2017年 Crane. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DKFileToolCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface DKFileTool : NSObject

+ (DKFileTool *)sharedTool;

#pragma mark - 文件操作
/** 获取 Document 目录下的文件路径 */
+ (NSString *)getFileInDocument:(NSString *)fileName;

/** 获取 Bundle 目录下的文件路径 */
+ (NSString *)getFileInBundle:(NSString *)fileName type:(NSString *)type;

/** 删除文件 */
+ (void)deleteFileWithName:(NSString *)uniquePath;

#pragma mark - 缓存
/** 获取该目录下文件大小 */
- (NSUInteger)getSizeForPath:(NSString *)fullNameDirectory;

- (NSString *)getMBForPath:(NSString *)fullNameDirectory;

/** 获取该目录下文件数量 */
- (NSUInteger)getDiskCountForPath:(NSString *)fullNameDirectory;

/** 获取该目录下文件大小 */
- (void)calculateSizeWithPath:(NSString *)fullNameDirectory
              completionBlock:(DKFileToolCalculateSizeBlock)completionBlock;



@end
