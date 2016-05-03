//
//  NSDate+CECategory.m
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "NSDate+CECategory.h"
#import <objc/runtime.h>

static char formatCacheKey;

@implementation NSDate (CECategory)


+ (NSString *)stringFromSeconds:(NSTimeInterval)seconds formatterStr:(NSString *)formatString {
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    return [self stringFromDate:d formatterStr:formatString];
}

+(NSDate *)dateFromDataString:(NSString *)dateString formatString:(NSString *)formatString
{
    NSCache *formaterCache = objc_getAssociatedObject(self, &formatCacheKey);
    if (!formaterCache) {
        formaterCache = [[NSCache alloc] init];
        objc_setAssociatedObject(self, &formatCacheKey, formaterCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSDateFormatter *formater = [formaterCache objectForKey:formatString];
    if (!formater) {
        formater = [[NSDateFormatter alloc] init];
        [formaterCache setObject:formater forKey:formatString];
    }
    
    [formater setDateFormat:formatString];
    return [formater dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date formatterStr:(NSString *)formatString
{
    NSCache *formaterCache = objc_getAssociatedObject(self, &formatCacheKey);
    if (!formaterCache) {
        formaterCache = [[NSCache alloc] init];
        objc_setAssociatedObject(self, &formatCacheKey, formaterCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSDateFormatter *formater = [formaterCache objectForKey:formatString];
    if (!formater) {
        formater = [[NSDateFormatter alloc] init];
        [formaterCache setObject:formater forKey:formatString];
    }
    
    [formater setDateFormat:formatString];
    return [formater stringFromDate:date];
}

//+ (NSTimeInterval)timerIntervalByDate:(NSDate *)date {
//
//    NSString *dateStr = [NSDate stringFromDate:[NSDate date] formatterStr:@"yyyy-MM-dd"];
//    NSDate *d = [NSDate dateFromDataString:dateStr formatString:@"yyyy-MM-dd"];
//
//    return [self timeIntervalStartDaySince1970:[d timeIntervalSince1970]];
// //   return [d timeIntervalSince1970];
//}

+ (NSDateComponents *)dateCompFromDate:(NSDate *)date
{
    NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSCalendarUnitWeekOfYear|NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date ];
    return comps;
}

+ (NSInteger)diffDayBetween:(NSDate *)startDate andDate:(NSDate *)endDate {
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *startCom = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
    NSDateComponents *endCom = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
    
    NSDate *start = [gregorian dateFromComponents:startCom];
    NSDate *end = [gregorian dateFromComponents:endCom];
    
    NSDateComponents *comps = [gregorian components:NSDayCalendarUnit fromDate:start  toDate:end  options:0];
    
    return [comps day];
}

+ (NSInteger)diffMonthBetween:(NSDate *)startDate andDate:(NSDate *)endDate {
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *startCom = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:startDate];
    NSDateComponents *endCom = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:endDate];
    
    NSDate *start = [gregorian dateFromComponents:startCom];
    NSDate *end = [gregorian dateFromComponents:endCom];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitMonth fromDate:start  toDate:end  options:0];
    
    return [comps month];
}

+ (NSDate *)dateByAddDays:(NSInteger)addDays fromDate:(NSDate *)fromDate {
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:addDays];
    
    return [gregorian dateByAddingComponents:comps toDate:fromDate options:0];
}

+ (NSDate *)dateByAddMonths:(NSInteger)addMonths fromDate:(NSDate *)fromDate {
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:addMonths];
    
    return [gregorian dateByAddingComponents:comps toDate:fromDate options:0];
}


@end
