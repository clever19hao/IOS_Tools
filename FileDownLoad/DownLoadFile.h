//
//  DownLoadFile.h
//  GoogFit
//
//  Created by cxq on 15/11/6.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    LoadStatus_uncomplete,
    
    LoadStatus_loading,
    
    LoadStatus_complete,
    
    LoadStatus_waitting,
    
}LoadStatus;

/* 如果下载的文件有更多的属性，请继承 */
@interface DownLoadFile : NSObject

@property (nonatomic,strong) NSString *urlStr;   //  视频的网络Url

@property (nonatomic,strong) NSString *saveName; //  存储在本地的地址，唯一关键字

@property (nonatomic,assign) UInt64     fileTotalLen;

@property (nonatomic,assign) UInt64     alreadyLoadLen;

@property (nonatomic,assign) LoadStatus loadStatus;

@property (nonatomic,strong) NSString *currentSpeed;

@end
