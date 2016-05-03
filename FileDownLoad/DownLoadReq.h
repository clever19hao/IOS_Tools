//
//  DownLoadReq.h
//  GoogFit
//
//  Created by cxq on 15/11/6.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NT_DownloadDidCompleteNotification (@"DownloadDidCompleteNotification")

typedef NS_ENUM(NSUInteger, DownLoadErrorType) {
    
    FreeDiskSpaceLack,      //磁盘空间不足错误
    GeneralErrorInfo,       //一般错误信息
    NetWorkErrorInfo        //网络工作错误
};

@interface DownLoadReq : NSOperation

@property (nonatomic,copy) void (^hasDownload)(DownLoadReq *req,BOOL has);//本地是否存在要下载的文件回调
@property (nonatomic,copy) void (^downloadProgress)(DownLoadReq *req,NSString *speed);
@property (nonatomic,copy) void (^downloadResult)(DownLoadReq *req,NSError *error);

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *saveDir;
@property (nonatomic,strong) NSString *downloadUrl;

@property (nonatomic,assign,readonly) BOOL isDownloadComplete;
@property (nonatomic,assign,readonly) BOOL isDownloading;

@property (nonatomic,assign,readonly) UInt64 totalLen;
@property (nonatomic,assign,readonly) UInt64 downloadLen;

- (void)cancelDownloadTaskWithDeleteFile:(BOOL)isDelete;

- (NSString *)saveFilePath;

@end
