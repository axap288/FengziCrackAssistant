//
//  FZDownloadManager.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-15.
//
//

#import "FZDownloadManager.h"

#define Archiverfilename @"DownloadManage.archive"
#define request_key @"downurl"


@interface FZDownloadManager()

/**
 *  将三个主要的数组归档到文件
 */
-(void)writeQueuesToArchiveFile;
/**
 *  从归档文件中还原
 */
-(void)readQueuesFromArchiveFile;

@end

@implementation FZDownloadManager
{
    ASINetworkQueue *queue;
    NSUInteger requestcount;
}

// 获取接口服务类单例
+ (FZDownloadManager *)getShareInstance
{
    static FZDownloadManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _maxDownLoad = 1;//默认只有一个下载
        requestcount = 0;
        
        [self readQueuesFromArchiveFile];
        
        //设置目录
        NSString *downloadPath = [self getDownloadPath];
        NSString *tempPath = [self getTempFolderPath];
        
        //目录不存在则创建目录
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL downloadPathExists = [fileManager fileExistsAtPath:downloadPath];
        if (!downloadPathExists) {
            [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        BOOL tempPathExists = [fileManager fileExistsAtPath:tempPath];
        if (!tempPathExists) {
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //设置网络请求队列
        ASINetworkQueue *myqueue = [[ASINetworkQueue alloc] init];
        [myqueue setShowAccurateProgress:YES];
        [myqueue go];
        queue = myqueue;
        
        //注册一个退出后台的通知，以便能及时保存数据
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundHandle) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundHandle) name:UIApplicationWillTerminateNotification object:nil];


        [self startDonwloadTimer];
    }
    return self;
}

-(void)startDonwloadTimer
{
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(donwloadEngine) userInfo:nil repeats:YES];
    [timer1 fire];
}

-(void)donwloadEngine
{
    if ([_downloadingQueue count] != 0) {
         if (requestcount < _maxDownLoad) {
             [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                  FZGameFile *object = obj;
                 if(object.state == waitting){
                     object.state = downloading;
                     [NSThread detachNewThreadSelector:@selector(createDownloadHttpRequest:) toTarget:self withObject:object];
//                     [self createDownloadHttpRequest:object];
                     *stop = YES;
                     [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
                 }
             }];
         }
    }
}

-(void)createDownloadHttpRequest:(FZGameFile *)model
{
    NSURL *downloadURL = [NSURL URLWithString:model.downloadUrl];
    
    //添加一个下载请求到队列
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:downloadURL];
    request.delegate = self;
    request.downloadProgressDelegate = self;
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setUserInfo:[NSDictionary dictionaryWithObject:model.downloadUrl forKey:request_key]];
    [request setDownloadDestinationPath:[[self getDownloadPath] stringByAppendingPathComponent:model.fileName]];
    [request setTemporaryFileDownloadPath:[[self getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",model.fileName]]];
    [request setAllowResumeForFileDownloads:YES];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request setTimeOutSeconds:60];
    [queue addOperation:request];
    requestcount ++;
}

-(void)addDownloadToList:(FZGameFile *)model
{
    __block BOOL isFindInDownloadQueue = NO;
    
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         FZGameFile *object = obj;
         if ([object.downloadUrl isEqualToString:model.downloadUrl]) {
             isFindInDownloadQueue = YES;
             *stop = YES;
         }
    }];
    
    if (isFindInDownloadQueue) {
        
    }else{
        model.state = waitting;
        [_downloadingQueue addObject:model];
    }
    
 
    /*
    //如果暂停队列中直接有这个下载，则提到等待队列中即可
    __block BOOL isFindinsuspendDownloadQueue = NO;
    [_suspendDownloadQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *suspendmodel = obj;
        if ([suspendmodel.downloadUrl isEqualToString:model.downloadUrl]) {
            //断点续传时需要将receviedSize重置为0.否则计算错误
            suspendmodel.receviedSize = @"0";
            suspendmodel.state = waitting;
            [_waitDownloadQueue addObject:suspendmodel];
            [_suspendDownloadQueue removeObject:suspendmodel];
            isFindinsuspendDownloadQueue = YES;
            *stop = YES;
        }
    }];
    
    if (!isFindinsuspendDownloadQueue) {
        model.state = waitting;
        [_waitDownloadQueue addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
     */
}

-(void)stopDownloadUseURL:(NSString *)URL
{
    for (ASIHTTPRequest *request in [queue operations]) {
        NSString *download_url = [request.userInfo objectForKey:request_key];
        if ([download_url isEqualToString:URL]) {//判断ID是否匹配
            //暂停下载
            [request clearDelegatesAndCancel];
            requestcount --;
        }
    }
    
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:URL]) {
            model.state = suspend;
            *stop = YES;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
}

-(void)restartDownloadUseURL:(NSString *)URL
{
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:URL]) {
            model.state = waitting;
            *stop = YES;
        }
    }];
}

-(void)removeOneWaittingUseURL:(NSString *)URL
{
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *waitmodel = obj;
        if ([waitmodel.downloadUrl isEqualToString:URL]) {
            [_downloadingQueue removeObject:waitmodel];
            *stop = YES;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
}

-(void)removeOneDownloadingUseURL:(NSString *)URL
{
    NSString *tempFilePath ;
    for (ASIHTTPRequest *request in [queue operations]) {
        NSString *download_url = [request.userInfo objectForKey:request_key];
        if ([download_url isEqualToString:URL]) {//判断ID是否匹配
            //暂停下载
            tempFilePath =  request.temporaryFileDownloadPath;
            [request clearDelegatesAndCancel];
            requestcount --;
        }
    }
    //转移队列
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:URL]) {
            model.state = downloading;
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
    
    //删除临时文件
    if (!tempFilePath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:tempFilePath error:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *userinfo =  request.userInfo;
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:[userinfo objectForKey:request_key]]) {
            NSLog(@"%@下载完毕", model.name);
            model.state = over;
            [_overDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            requestcount --;
            *stop = YES;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *userinfo =  request.userInfo;
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:[userinfo objectForKey:request_key]]) {
            NSLog(@"%@下载失败", model.name);
            model.state = suspend;
            requestcount --;
            *stop = YES;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil userInfo:nil];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    NSDictionary *userinfo =  request.userInfo;
    NSLog(@"request.contentLength:%@",[NSString stringWithFormat:@"%lld",request.contentLength]);
     [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         FZGameFile *model = obj;
         if ([model.downloadUrl isEqualToString:[userinfo objectForKey:request_key]]) {
             if (!model.fileSize || [model.fileSize longLongValue] == 0) {
                 model.fileSize = [NSString stringWithFormat:@"%lld",request.contentLength];
                 NSLog(@"filesize:%@", model.fileSize);
             }else{
                 model.receviedSize = @"0";
                 model.last_receviedSize = @"0";
             }
             *stop = YES;
         }
     }];
    
}

#pragma mark ASIProgressDelegate

-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    
    NSDictionary *userinfo =  request.userInfo;
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *gamefile = obj;
        if ([gamefile.downloadUrl isEqualToString:[userinfo objectForKey:request_key]]) {
            gamefile.last_receviedSize = gamefile.receviedSize;
            gamefile.receviedSize =  [NSString stringWithFormat:@"%lld",[gamefile.receviedSize longLongValue]+bytes];
        
//            NSLog(@"total receviceSize:%@,revice%@",gamefile.receviedSize,[NSString stringWithFormat:@"%lld",bytes]);
            
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:gamefile forKey:@"refresObject"];
            [[NSNotificationCenter defaultCenter] postNotificationName:didReceiverefreshNotification object:nil userInfo:nil];
        }
    }];
}

-(void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    /*
    NSDictionary *userinfo =  request.userInfo;
    [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.downloadUrl isEqualToString:[userinfo objectForKey:request_key]]) {
            model.fileSize = [NSString stringWithFormat:@"%lld",request.contentLength];
            NSLog(@"filesize:%@",model.fileSize);
            *stop = YES;
        }
    }];
     */
}


-(void)writeQueuesToArchiveFile
{
    //先暂停所有正在下载的任务
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *gamefile = (FZGameFile *)obj;
        [self stopDownloadUseURL:gamefile.downloadUrl];
    }];
    
    NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:
        _downloadingQueue,@"downloadingQueue",
        _overDownloadQueue,@"overDownloadQueue",nil];
    
    NSString *archiveFilePath = [[self getDocumentPath] stringByAppendingPathComponent:Archiverfilename];
    [NSKeyedArchiver archiveRootObject:temp toFile:archiveFilePath];
}

-(void)readQueuesFromArchiveFile
{
    NSString *archiveFilePath = [[self getDocumentPath] stringByAppendingPathComponent:Archiverfilename];
    NSDictionary *temp = [NSKeyedUnarchiver unarchiveObjectWithFile: archiveFilePath];
    if (temp) {
        _downloadingQueue = [temp objectForKey:@"downloadingQueue"];
        _overDownloadQueue = [temp objectForKey:@"overDownloadQueue"];
    }else{
        _overDownloadQueue = [NSMutableArray array];
        _downloadingQueue = [NSMutableArray array];
    }

}

-(void)applicationDidEnterBackgroundHandle
{
    NSLog(@"ArchiveFile.....");
    [self writeQueuesToArchiveFile];
}


#pragma mark tools
-(NSString *)getDownloadPath
{
    NSString *downloadPath = [[self getDocumentPath] stringByAppendingPathComponent:@"Download"];
    return downloadPath;
}
     
-(NSString *)getDocumentPath
{
        return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
     
-(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}


-(void)dealloc
{
    [queue setDelegate:nil];
    [queue cancelAllOperations];
    [self writeQueuesToArchiveFile];
}



@end
