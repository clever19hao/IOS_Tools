//
//  NSString+CECategory.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CECategory)

- (BOOL)isValidateEmail;

- (BOOL)isValidatephoneNum;

/**
 *  返回字符串类型 0:全小写 1:全大写 2:大小写结合
 *
 *  @return 0:全小写 1:全大写 2:大小写结合
 */
- (NSInteger)stringType;

- (NSString *)fileNameAppendExtension:(NSString *)extension;

- (NSString *)md5String;

@end
