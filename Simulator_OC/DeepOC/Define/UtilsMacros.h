//
//  UtilsMacros.h
//  DeepOC
//
//  Created by 邓凯 on 2018/5/26.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

/* ------------------------- 打印日志信息 -------------------------- */
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(@"\n%s 第%d行📍\n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define NSLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#define NSLogInt(integer) NSLog(@"%zd", integer);
#define NSLogChar(char) NSLog(@"%c", char);
#define NSLogString(string) NSLog(@"%@", string);
#define NSLogFloat(float) NSLog(@"%.f", float);
#else
#define NSLog(...)
#define NSLOG_CURRENT_METHOD
#define NSLogInt(integer)
#define NSLogChar(char)
#define NSLogString(string)
#define NSLogFloat(float)
#define DEBUG 0
#endif

//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)


/* ------------------------- 循环引用 -------------------------- */
#ifndef WeakSelf
#if DEBUG
#if __has_feature(objc_arc)
#define WeakSelf(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define WeakSelf(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define WeakSelf(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define WeakSelf(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef StrongSelf
#if DEBUG
#if __has_feature(objc_arc)
#define StrongSelf(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define StrongSelf(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define StrongSelf(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define StrongSelf(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


/* ------------------------- 坐标尺寸 -------------------------- */
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define DKSize(w, h)            CGSizeMake(w, h)


/* ------------------------- 图片 -------------------------- */
//定义UIImage对象
#define DKImageName(name)       [UIImage imageNamed:name]
#define DKImageFile(_pointer)   [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define DKPlaceImage            DKImageName(@"banner_placeholder")



/* ------------------------- 宏作用:单例生成宏 -------------------------- */
#define DEFINE_SINGLETON_INTERFACE(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_IMPLEMENTATION(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

/* ------------------------------- 输入限制 ------------------------------- */

#define kNumbers                @"0123456789"
#define kNumbersPeriod          @"0123456789."
#define kAlpha                  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kAlphaNum               @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

/* ------------------------------- 字符串串处理 ------------------------------- */

#define kNullString(_str)       ((_str == nil) || [_str isEqual:[NSNull null]])?@"":_str
#define kIsNullString(_str)     ((_str == nil) || [_str isEqual:[NSNull null]] || [_str isEqual:@""])?YES:NO
#define kIsNotNullString(_str)     !kIsNullString(_str)

#define kEmptyString(_str)      ((_str == nil) || [_str isEqual:[NSNull null]] || !_str.length)?@"":_str
#define kIsEmptyString(_str)        ((_str == nil) || [_str isEqual:[NSNull null]] || !_str.length)?YES:NO
#define kIsNotEmptyString(_str)     !kIsEmptyString(_str)

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

/* -------------------------------- block ---------------------------------- */

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); }


/* -------------------------------- Debug ---------------------------------- */
#define DKDebugCode(code) if (DKDebug) {code;};

#define DKDebugCodeElse(debug, release) if (DKDebug){debug;}else{release;};


#endif /* UtilsMacros_h */
