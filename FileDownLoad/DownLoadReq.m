//
//  DownLoadReq.m
//  GoogFit
//
//  Created by cxq on 15/11/6.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "DownLoadReq.h"

#define CE_DOMAIN                                   @"DownLoadReq"
#define CE_InvainUrl                              (@"无效的url%@")
#define CE_RequestRange                           (@"bytes=%lld-")
#define CE_DownloadSpeedDuring                    (1.5)
#define CE_ErrorCode                              (@"错误码:%ld")
#define CE_FreeDiskSapceError                     (@"磁盘可用空间不足需要存储空间:%llu")
#define CE_WriteSizeLen                           (1024 * 100)

@interface DownLoadReq ()

@property (nonatomic,strong) NSURLConnection *urlConnection;//网络连接

@property (nonatomic,strong) NSMutableData *downloadData;//文件数据存储
@property (nonatomic,strong) NSFileHandle *fileHandle;//文件句柄
@property (nonatomic,assign) UInt64 lastFileLen;//保存的文件大小

@property (nonatomic,strong) NSTimer *timer;//定时器，用于计算下载速度
@property (nonatomic,assign) UInt64  perTimeReceiveLen;//单位时间内接收的数据长度
@property (nonatomic,strong) NSString *downloadSpeed;//下载速度

@end

@implementation DownLoadReq

- (NSString *)fileName {
    
    if (_fileName) {
        return _fileName;
    }
    
    return [_downloadUrl lastPathComponent];
}

- (NSString *)saveFilePath {
    
    return [_saveDir stringByAppendingPathComponent:self.fileName];
}

//取消下载,是否删除
- (void)cancelDownloadTaskWithDeleteFile:(BOOL)isDelete {
    
    if (_downloadData.length && _fileHandle) {
        
        [_fileHandle writeData:_downloadData];
        [_downloadData setLength:0];
    }
    
    _isDownloading = NO;
    _isDownloadComplete = isDelete;
    
    [self cancelledDownloadNotify];
    
    if (isDelete) {
        
        NSFileManager  * fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:self.saveFilePath]){
            __autoreleasing  NSError  * error = nil;
            [fm removeItemAtPath:self.saveFilePath error:&error];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.hasDownload) {
            self.hasDownload(self,NO);
        }
    });
}

#pragma mark - privateMethod

- (void)handleDownloadError:(NSError *)error isDeleteFile:(BOOL)isDelete {
    
    if(error == nil){
        error = [[NSError alloc]initWithDomain:CE_DOMAIN
                                          code:GeneralErrorInfo
                                      userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:CE_InvainUrl,_downloadUrl]}];
    }
    
    NSFileManager  * fm = [NSFileManager defaultManager];
    
    if(isDelete && [fm fileExistsAtPath:self.saveFilePath]) {
        __autoreleasing  NSError  * error = nil;
        [fm removeItemAtPath:self.saveFilePath error:&error];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.downloadResult) {
            self.downloadResult(self,error);
        }
    });
}

- (void)cancelledDownloadNotify {
    
    if (_timer) {
        [_timer invalidate];
        [_timer fire];
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NT_DownloadDidCompleteNotification object:self];
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isCancelled"];
    [_urlConnection cancel];
    [_fileHandle synchronizeFile];
    [_fileHandle closeFile];
    _fileHandle = nil;
    _urlConnection = nil;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isCancelled"];
}

- (unsigned long long)calculateFreeDiskSpace {
    
    unsigned long long  freeDiskLen = 0;
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager  * fm   = [NSFileManager defaultManager];
    NSDictionary   * dict = [fm attributesOfFileSystemForPath:docPath error:nil];
    if(dict){
        freeDiskLen = [dict[NSFileSystemFreeSize] unsignedLongLongValue];
    }
    return freeDiskLen;
}

- (void)calculateDownloadSpeed {
    
    float downloadSpeed = (float)_perTimeReceiveLen / (CE_DownloadSpeedDuring * 1024.0);
    _downloadSpeed = [NSString stringWithFormat:@"%.1fKB/S", downloadSpeed];
    if(downloadSpeed >= 1024.0){
        downloadSpeed = ((float)_perTimeReceiveLen / 1024.0) / (CE_DownloadSpeedDuring * 1024.0);
        _downloadSpeed = [NSString stringWithFormat:@"%.1fMB/S",downloadSpeed];
    }
    _perTimeReceiveLen = 0;
}

- (void)dealloc{
    _isDownloadComplete = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NT_DownloadDidCompleteNotification object:self];
}

#pragma mark - OverrideMethod
- (void)start {
    
    NSMutableURLRequest  * urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_downloadUrl]
                                                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                 timeoutInterval:60];
    //检测该请求是否合法
    if(![NSURLConnection canHandleRequest:urlRequest]) {
        
        [self handleDownloadError:nil isDeleteFile:YES];
    }
    else {
        __autoreleasing  NSError  * error = nil;
        NSFileManager  * fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:self.saveFilePath]){
            [fm createFileAtPath:self.saveFilePath contents:nil attributes:nil];
        }
        else {
            _lastFileLen = [[fm attributesOfItemAtPath:self.saveFilePath error:&error] fileSize];
            NSString  * strRange = [NSString stringWithFormat:CE_RequestRange ,_lastFileLen];
            [urlRequest setValue:strRange forHTTPHeaderField:@"Range"];
        }
        
        if(error == nil) {
            
            _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.saveFilePath];
            [_fileHandle seekToEndOfFile];
            _downloadData = [NSMutableData new];
            if(_urlConnection == nil){
                _urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
            }
            
            NSRunLoop * urnLoop = [NSRunLoop currentRunLoop];
            [_urlConnection scheduleInRunLoop:urnLoop forMode:NSDefaultRunLoopMode];
            [self willChangeValueForKey:@"isExecuting"];
            [_urlConnection start];
            [self didChangeValueForKey:@"isExecuting"];
            [urnLoop run];
            
        }
    }
}

- (BOOL)isFinished{
    return _urlConnection == nil;
}

- (BOOL)isCancelled{
    return _urlConnection == nil;
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isAsynchronous{
    return YES;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self cancelledDownloadNotify];
    [self handleDownloadError:error isDeleteFile:NO];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    
    BOOL  isCancel = YES;
    _totalLen = response.expectedContentLength + _lastFileLen;
    
    NSHTTPURLResponse  *  headerResponse = (NSHTTPURLResponse *)response;
    if(headerResponse.statusCode >= 400) {
        
        if(headerResponse.statusCode == 416) {
            
            _isDownloadComplete = YES;
            
            [self cancelledDownloadNotify];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.hasDownload) {
                    self.hasDownload(self,YES);
                }
            });
            
            return;
        }
        else{
            __autoreleasing NSError  * error = [[NSError alloc]initWithDomain:CE_DOMAIN code:NetWorkErrorInfo userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:CE_ErrorCode,(long)headerResponse.statusCode]}];
            [self handleDownloadError:error isDeleteFile:YES];
        }
    }
    else {
        if([self calculateFreeDiskSpace] < _totalLen) {
            __autoreleasing NSError  * error = [[NSError alloc]initWithDomain:CE_DOMAIN code:FreeDiskSpaceLack userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:CE_FreeDiskSapceError,_totalLen]}];
            [self handleDownloadError:error isDeleteFile:YES];
        }
        else {
            _isDownloading = YES;
            _downloadLen = _lastFileLen;
            _perTimeReceiveLen = 0;
            _timer = [NSTimer scheduledTimerWithTimeInterval:CE_DownloadSpeedDuring target:self selector:@selector(calculateDownloadSpeed) userInfo:nil repeats:YES];
            isCancel = NO;
            [_downloadData setLength:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.hasDownload) {
                    self.hasDownload(self,NO);
                }
            });
            
            [self calculateDownloadSpeed];
        }
    }
    
    if(isCancel) {
        [self cancelDownloadTaskWithDeleteFile:NO];
    }
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [_downloadData appendData:data];
    _downloadLen += data.length;
    _perTimeReceiveLen += data.length;
    
    if(_downloadData.length > CE_WriteSizeLen && _fileHandle) {
        
        [_fileHandle writeData:_downloadData];
        [_downloadData setLength:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.downloadProgress) {
                self.downloadProgress(self,_downloadSpeed);
            }
        });
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    
    if(_fileHandle){
        [_fileHandle writeData:_downloadData];
        [_downloadData setLength:0];
    }
    
    _isDownloadComplete = YES;
    _isDownloading = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.downloadResult) {
            self.downloadResult(self,nil);
        }
    });
    
    [self cancelledDownloadNotify];
}


@end
