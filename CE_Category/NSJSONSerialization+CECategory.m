//
//  NSJSONSerialization+CECategory.m
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "NSJSONSerialization+CECategory.h"

@implementation NSJSONSerialization (CECategory)

/**
 *  将字典或者数组转化成json字符串
 *
 *  @param obj 字典或者数组
 *
 *  @return jsonstring
 */
+ (NSString *)jsonObjToString:(id)obj {
    
    if(!obj)
        return nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 *  将json字符串转化成字典或者数组
 *
 *  @param string json string
 *
 *  @return 字典或者数组
 */
+ (id)jsonStringToObj:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return json;
}

@end
