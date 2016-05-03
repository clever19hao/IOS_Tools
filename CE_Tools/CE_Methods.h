//
//  CE_Methods.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _progressHudShowView(_hudName,_view,_text,_frame) do\
{\
_progressHudHide(_hudName);\
_hudName = [[MBProgressHUD alloc] initWithFrame:(_frame)];\
[_view addSubview:_hudName];\
[_view bringSubviewToFront:_hudName];\
_hudName.labelText = (_text);\
_hudName.mode = MBProgressHUDModeCustomView;\
[MBProgressHUD addProgress:_hudName]; \
[_hudName show:YES];\
}while(0)


//隐藏progress hud
#define _progressHudHide(_hudName) do\
{\
if (_hudName){\
[_hudName hide:YES];\
[_hudName removeFromSuperview];\
_hudName = nil;\
}\
}while(0)

@interface CE_Methods : NSObject

/**
 *  显示弹出框,不一定是UIAlertView，也可以是自定义的弹出框
 *
 *  @param title       弹出框的标题，参数如果为nil，则显示@"提示"，如果为@“”，则不显示标题
 *  @param message     弹出框的内容
 *  @param return
 */
+ (void)msgBoxWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  计算字符串的size，单行显示
 *
 *  @param str      计算的字符串
 *  @param font     字符串显示的字体
 *  @param return   字符串的现实范围
 */
+ (CGSize)getStrSize:(NSString *)str font:(UIFont *)font;

/**
 *  计算字符串的size，可多行显示
 *
 *  @param str                  计算的字符串
 *  @param font                 字符串显示的字体
 *  @param containSize          字符串显示的区域,用MAXFLOAT来指定宽或高为可变
 *  @param return               字符串的现实范围
 */
+ (CGSize)getStrSize:(NSString *)str font:(UIFont *)font containSize:(CGSize)containSize;

/**
 *  获取App的uuid
 *
 *  @param return               当前的uuid
 */
+ (NSString *)getAppUUID;

/**
 *  生成一个富文本字符串
 *
 *  @param textInfoArray        一个个字符片段，eg: @[@{@"text":str1,@"font":font1,@"color":color1},@{@"text":str2,@"font":font2,@"color":color2}]
 *  @param return               返回组合的富文本
 */
+ (NSMutableAttributedString *)generateAttributeStringBy:(NSArray <NSDictionary *> *)textInfoArray;

+ (void)filterTextLenth:(UITextField *)textField limit:(NSInteger)len;

+ (NSMutableAttributedString *)getAttributeStringWith:(NSArray *)textInfoArray;



@end
