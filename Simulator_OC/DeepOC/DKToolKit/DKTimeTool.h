//
//  DKTimeTool.h
//  LicensedBroker
//
//  Created by 邓凯 on 2017/12/18.
//  Copyright © 2017年 邓凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKTimeTool : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormat;

@property (nonatomic, strong) NSDateFormatter *debugDateFormat;

@property (nonatomic, strong) NSCalendar *calendar;

+ (DKTimeTool *)sharedTool;


// 获取当前时间 "yyyy'年'MM'月'dd'日' HH:mm:ss"
+ (NSString *)date;
// 获取当前时间 "yyyy'年'MM'月'dd'日' HH:mm"
+ (NSString *)dateFormatString;
// 20150214 --> 2015-2 or 2015-2-14
+ (NSString *)displayDateFormatWithDateStr:(NSString *)dateStr formatStr:(NSString *)formatStr;

// 将时间戳转换为日期字符串
+ (NSString *)dateWithTimeIntervelString:(NSString *)timeIntervel;

// 将日期字符串转换为时间戳
+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString format:(NSDateFormatter *)format;

+ (NSString *)dateWithTimeIntervel:(NSInteger)timeIntervel;

// 根据日期,获取格式化时间字符串
+ (NSString *)dateStringWithDate:(NSDate *)date;

// 根据日期,获取时间戳
+ (NSTimeInterval)dateTimeIntervel;
@end
