//
//  CE_define.h
//  CommanApp
//
//  Created by cxq on 15/12/9.
//  Copyright © 2015年 cxq. All rights reserved.
//

#ifndef CE_define_h
#define CE_define_h

#define HOST            @"192.168.4.154"//@"192.168.4.133"//192.168.4.183
#define PORT            @"8080"

#define DIR_TMP            NSTemporaryDirectory()
#define DIR_DOC           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define MAINVIEWHEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAINVIEWWIDTH [[UIScreen mainScreen] bounds].size.width
#define DIFF_7              ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? 20.0 : 0.0)//从ios6到ios7 y值的变化

#define weak(name) __weak __typeof(self)weakSelf = self

#define X_(x)  (((x) * MAINVIEWWIDTH)/375.0)                    //x方向上比例缩放
#define Y_(y)  (((MAINVIEWHEIGHT - DIFF_7)/(667.0 - DIFF_7)) * y) //y方向上比例缩放，
#define YT_(y) (((MAINVIEWHEIGHT - 64)/(667.0 -64)) * y)          //y方向上比例缩放，只有导航栏
#define YTB_(y) (((MAINVIEWHEIGHT - 64 - 49)/(667.0 - 64 - 49)) * y) //y方向上比例缩放，有导航栏和tabbar

#endif /* CE_define_h */
