//
//  NSObject+CECategory.m
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "NSObject+CECategory.h"

@implementation NSObject (CECategory)

- (NSString *)safeStringValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self stringValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return self ? (NSString *)self : @"";
    }
    
    return @"";
}

- (NSInteger)safeIntegerValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self integerValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self integerValue];
    }
    
    return 0;
}

- (long long)safeLongLongValue {
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self longLongValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self longLongValue];
    }
    
    return 0;
}

@end
