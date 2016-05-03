//
//  NSObject+CECategory.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CECategory)

- (NSString *)safeStringValue;

- (NSInteger)safeIntegerValue;

- (long long)safeLongLongValue;

@end
