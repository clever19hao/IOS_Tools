//
//  CE_Methods.m
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "CE_Methods.h"

@implementation CE_Methods

+ (CE_Methods *)shareInstance {
    
    static dispatch_once_t once;
    static CE_Methods *ins = nil;
    
    dispatch_once(&once, ^{
        
        if (!ins) {
            ins = [[CE_Methods alloc] init];
        }
    });
    
    return ins;
}

/**
 *  显示弹出框,不一定是UIAlertView，也可以是自定义的弹出框
 *
 *  @param title       弹出框的标题，参数如果为nil，则显示@"提示"，如果为@“”，则不显示标题
 *  @param message     弹出框的内容
 *  @param return
 */
+ (void)msgBoxWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title ? title : @"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
    [alertView show];
}

/**
 *  计算字符串的size，单行显示
 *
 *  @param str      计算的字符串
 *  @param font     字符串显示的字体
 *  @param return   字符串的现实范围
 */
+ (CGSize)getStrSize:(NSString *)str font:(UIFont *)font {
    
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: font}];
    return size;
}

/**
 *  计算字符串的size，可多行显示
 *
 *  @param str                  计算的字符串
 *  @param font                 字符串显示的字体
 *  @param containSize          字符串显示的区域,用MAXFLOAT来指定宽或高为可变
 *  @param return               字符串的现实范围
 */
+ (CGSize)getStrSize:(NSString *)str font:(UIFont *)font containSize:(CGSize)containSize {
    
    CGRect rect = [str boundingRectWithSize:containSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size;
}

/**
 *  获取App的uuid
 *
 *  @param return               当前的uuid
 */
+ (NSString *)getAppUUID {
    
    NSString *retStr = nil;
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    
    if (uuidRef) {
        
        retStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
    }
    
    return retStr;
}

/**
 *  生成一个富文本字符串
 *
 *  @param textInfoArray        一个个字符片段，eg: @[@{@"text":str1,@"font":font1,@"color":color1},@{@"text":str2,@"font":font2,@"color":color2}]
 *  @param return               返回组合的富文本
 */
+ (NSMutableAttributedString *)generateAttributeStringBy:(NSArray <NSDictionary *> *)textInfoArray {
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *textInfo in textInfoArray) {
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[textInfo objectForKey:@"text"] attributes:@{NSForegroundColorAttributeName:[textInfo objectForKey:@"color"],NSFontAttributeName:[textInfo objectForKey:@"font"]}];
        
        [attributeStr appendAttributedString:attr];
    }
    
    return attributeStr;
}

+ (void)filterTextLenth:(UITextField *)textField limit:(NSInteger)len {
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"] || [lang isEqualToString: @"ja-JP"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > len) {
                textField.text = [toBeString substringToIndex:len];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > len) {
            textField.text = [toBeString substringToIndex:len];
        }
    }
}


//AttributedString 切割
+ (NSMutableAttributedString *)getAttributeStringWith:(NSArray *)textInfoArray {
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *textInfo in textInfoArray) {
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[textInfo objectForKey:@"text"] attributes:@{NSForegroundColorAttributeName:[textInfo objectForKey:@"color"],NSFontAttributeName:[textInfo objectForKey:@"font"]}];
        
        [attributeStr appendAttributedString:attr];
    }
    
    return attributeStr;
}



@end
