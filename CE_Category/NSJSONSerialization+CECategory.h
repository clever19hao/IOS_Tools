//
//  NSJSONSerialization+CECategory.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (CECategory)

/**
 *  将字典或者数组转化成json字符串
 *
 *  @param obj 字典或者数组
 *
 *  @return jsonstring
 */
+ (NSString *)jsonObjToString:(id)obj;

/**
 *  将json字符串转化成字典或者数组
 *
 *  @param string json string
 *
 *  @return 字典或者数组
 */
+ (id)jsonStringToObj:(NSString *)string;

@end
