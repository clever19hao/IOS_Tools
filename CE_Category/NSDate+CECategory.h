//
//  NSDate+CECategory.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CECategory)

//将距1970年秒数按照格式转换成字符串
+ (NSString *)stringFromSeconds:(NSTimeInterval)seconds formatterStr:(NSString *)formatString;

//将日期按照格式转换成字符串（频繁的创建formatter影响性能）
+ (NSString *)stringFromDate:(NSDate *)date formatterStr:(NSString *)formatter;

//将符合格式的字符串转化成日期（频繁的创建formatter影响性能）
+ (NSDate *)dateFromDataString:(NSString *)dateString formatString:(NSString *)formatString;

//获取制定日期0点0分0秒距1970年的秒数
//+ (NSTimeInterval)timerIntervalByDate:(NSDate *)date;

//年月日转化成字符串
+(NSDateComponents *)dateCompFromDate:(NSDate *)date;

//小时不予计算，只计算天数
+ (NSInteger)diffDayBetween:(NSDate *)startDate andDate:(NSDate *)endDate;

//小时天数不予计算，只计算月份
+ (NSInteger)diffMonthBetween:(NSDate *)startDate andDate:(NSDate *)endDate;

//增加天数
+ (NSDate *)dateByAddDays:(NSInteger)addDays fromDate:(NSDate *)fromDate;

//增加月份
+ (NSDate *)dateByAddMonths:(NSInteger)addMonths fromDate:(NSDate *)fromDate;

@end
