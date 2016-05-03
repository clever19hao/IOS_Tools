//
//  NSString+CECategory.m
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "NSString+CECategory.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (CECategory)

- (BOOL)isValidateEmail
{
    NSString *email = self;
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidatephoneNum
{
    NSString *phoneNum = self;
    //    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regexPhone = @"^1\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhone];
    return [pred evaluateWithObject:phoneNum];

}

- (NSInteger)stringType {
    
    NSData *strData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if ([strData length] < 1) {
        return  1;
    }
    
    UInt8 c;
    [strData getBytes:&c range:NSMakeRange(0, 1)];
    
    NSInteger type = isupper(c) > 0 ? 1 : 0;
    
    for (int i = 1; i < [strData length]; i++) {
        
        [strData getBytes:&c range:NSMakeRange(i, 1)];
        
        if (isalpha(c) == 0) {
            return 2;
        }
        
        NSInteger tmpType = isupper(c) > 0 ? 1 : 0;
        
        if (tmpType != type) {
            return 2;
        }
    }
    
    return type;
}

- (NSString *)fileNameAppendExtension:(NSString *)extension {
    
    if ([extension length] < 1) {
        return self;
    }
    
    return [self stringByAppendingPathExtension:extension];
}

- (NSString *)md5String {
    
    NSData *strData = [self dataUsingEncoding:NSUTF8StringEncoding];
    const char* original_str = (const char *)[strData bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG)strData.length, digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i < CC_MD5_DIGEST_LENGTH; i++){
        
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    return [outPutStr lowercaseString];
}

@end
