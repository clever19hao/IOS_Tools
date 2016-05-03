//
//  DownLoadManager.m
//  GoogFit
//
//  Created by cxq on 15/11/6.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "DownLoadManager.h"
#import "DownLoadReq.h"
#import "DownLoadFile.h"

@implementation DownLoadManager
{
    NSOperationQueue      *_downloadQueue;   //下载队列
    NSMutableArray *downloadList;
}

+ (DownLoadManager *)shareManager {
    
    static  DownLoadManager  *ins = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        ins = [DownLoadManager new];
    });
    return ins;
}

- (instancetype)init {
    
    self = [super init];
    if(self){
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (NSArray *)downloadFileList {
    
    if (!downloadList) {
        
        downloadList = [NSMutableArray arrayWithCapacity:1];
    }
    
    return downloadList;
}

- (DownLoadFile *)downloadFileByName:(NSString *)keyName {
    
    DownLoadFile *file = nil;
    
    for (DownLoadFile *tmp in [self downloadFileList]) {
        
        if ([tmp.saveName isEqualToString:keyName]) {
            
            file = tmp;
            
            break;
        }
    }
    
    return file;
}

- (void)deleteDownloadFile:(NSString *)saveName {
    
    DownLoadFile *fileLoad = [[DownLoadFile alloc] init];
    fileLoad.saveName = saveName;
    
    for (DownLoadFile *tmp in downloadList) {
        
        if ([tmp.saveName isEqualToString:saveName]) {
            
            [downloadList removeObject:tmp];
            
            break;
        }
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:saveName] error:nil];
    
}

- (void)cancelDownloadReq:(NSString *)saveName {
    
    for (DownLoadReq *req in _downloadQueue.operations) {
        
        if ([saveName isEqualToString:req.fileName]) {
            
            [req cancelDownloadTaskWithDeleteFile:NO];
            
            break;
        }
    }
}

- (DownLoadFile *)downloadWithUrl:(NSString *)url saveDir:(NSString *)dir saveName:(NSString *)saveName {
    
    for (DownLoadReq * tmp in _downloadQueue.operations) {
        
        if ([saveName isEqualToString:tmp.fileName]) {
            
            return nil;
        }
    }
    
    DownLoadFile *file = [self downloadFileByName:saveName];
    
    if (!file) {
        file = [[DownLoadFile alloc] init];
        file.saveName = saveName;
        file.urlStr = url;
        [downloadList addObject:file];
    }
    
    DownLoadReq *downReq = [[DownLoadReq alloc] init];
    downReq.fileName = saveName;
    downReq.saveDir = dir;
    downReq.downloadUrl = url;
    downReq.hasDownload = ^(DownLoadReq *req,BOOL has) {
        
        if (has) {
            
            file.loadStatus = LoadStatus_complete;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NT_DOWNLOADFILE_CHANGED object:file];
        }
    };
    
    downReq.downloadResult =  ^(DownLoadReq *req,NSError *error) {
        
        if (!error) {
            file.loadStatus = LoadStatus_complete;
        }
        else {
            file.loadStatus = LoadStatus_uncomplete;
        }
        
        file.fileTotalLen = req.totalLen;
        file.alreadyLoadLen = req.downloadLen;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NT_DOWNLOADFILE_CHANGED object:file];
    };
    
    downReq.downloadProgress = ^(DownLoadReq *req,NSString *speed) {
        
        file.loadStatus = LoadStatus_loading;
        file.fileTotalLen = req.totalLen;
        file.alreadyLoadLen = req.downloadLen;
        file.currentSpeed = speed;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NT_DOWNLOADFILE_CHANGED object:file];
    };
    
    [_downloadQueue addOperation:downReq];
    
    return file;
}

@end
