//
//  DownLoadManager.h
//  GoogFit
//
//  Created by cxq on 15/11/6.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NT_DOWNLOADFILE_CHANGED  @"NT_DOWNLOADFILE_CHANGED"

@class DownLoadFile;

/* 文件下载类，支持大文件继续下载 */
@interface DownLoadManager : NSObject

+ (DownLoadManager *)shareManager;

- (NSArray *)downloadFileList;

- (DownLoadFile *)downloadFileByName:(NSString *)keyName;

- (DownLoadFile *)downloadWithUrl:(NSString *)url saveDir:(NSString *)dir saveName:(NSString *)saveName;

- (void)cancelDownloadReq:(NSString *)saveName;

- (void)deleteDownloadFile:(NSString *)saveName;

@end
