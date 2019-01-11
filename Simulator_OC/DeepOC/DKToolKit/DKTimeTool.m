//
//  DKTimeTool.m
//  LicensedBroker
//
//  Created by 邓凯 on 2017/12/18.
//  Copyright © 2017年 邓凯. All rights reserved.
//

#import "DKTimeTool.h"

@implementation DKTimeTool

+ (DKTimeTool *)sharedTool {
    static DKTimeTool *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy年MM月dd日"];
        
        _debugDateFormat = [[NSDateFormatter alloc] init];
        [_debugDateFormat setDateFormat:@"yyyy'年'MM'月'dd'日' HH:mm:ss:SSS"];
    }
    return self;
}

+ (NSString *)dateWithTimeIntervelString:(NSString *)timeIntervel {
    return [self dateWithTimeIntervel:timeIntervel.integerValue];
}

// 将日期字符串转换为时间戳
+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString format:(NSDateFormatter *)format {
    NSDate *date = [format dateFromString:dateString];
    return [date timeIntervalSince1970];;
}

+ (NSString *)dateWithTimeIntervel:(NSInteger)timeIntervel {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel];
    NSString *dateString = [[DKTimeTool sharedTool].dateFormat stringFromDate:date];
    return dateString;
}

+ (NSTimeInterval)dateTimeIntervel {
    return [NSDate date].timeIntervalSince1970;
}

#pragma mark - 时间
+ (NSString *)date
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [DKTimeTool sharedTool].debugDateFormat;
    NSString *time = [dateFormat stringFromDate:date];
    
    return time;
}

+ (NSString *)dateFormatString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [DKTimeTool sharedTool].debugDateFormat;
    NSString *time = [dateFormat stringFromDate:date];
    
    return time;
}

+ (NSString *)displayDateFormatWithDateStr:(NSString *)dateStr formatStr:(NSString *)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSCalendar *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags     = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year  = [comps year];
    NSInteger month = [comps month];
    NSInteger day   = [comps day];
    
    if ([formatStr isEqualToString:@"%lu-%lu"]) {
        return [NSString stringWithFormat:@"%zd-%zd", year, month];
    }else {
        return [NSString stringWithFormat:@"%zd-%zd-%zd", year, month, day];
    }
}

// 根据日期,日期格式,获取时间字符串
+ (NSString *)dateStringWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *time = [dateFormat stringFromDate:date];
    return time;
}

// 根据日期,获取格式化时间字符串
+ (NSString *)dateStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [DKTimeTool sharedTool].debugDateFormat;
    NSString *time = [dateFormat stringFromDate:date];
    return time;
}

@end
