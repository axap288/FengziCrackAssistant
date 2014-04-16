//
//  FZDownloadManager.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-15.
//
//

#import "FZDownloadManager.h"


@implementation FZDownloadManager
{
    ASINetworkQueue *queue;
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
        _maxDownLoad = 2;//默认只有一个下载
        _waitDownloadQueue = [NSMutableArray array];
        _overDownloadQueue = [NSMutableArray array];
        _suspendDownloadQueue = [NSMutableArray array];
        _downloadingQueue = [NSMutableArray array];
        
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
    }
    return self;
}

-(void)addDownloadToList:(FZGameFile *)model
{
    
    if ([queue requestsCount] < _maxDownLoad) {
        [self createDownloadHttpRequest:model];
    }else{
        model.state = waitting;
        [_waitDownloadQueue addObject:model];
    }
}

-(void)stopDownloadWithGameId:(NSString *)mid
{
    for (ASIHTTPRequest *request in [queue operations]) {
        NSString *modelid = [request.userInfo objectForKey:@"id"];
        if ([mid isEqualToString:modelid]) {//判断ID是否匹配
            //暂停下载
            [request clearDelegatesAndCancel];
        }
    }
    //转移队列
    [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:mid]) {
            model.state = suspend;
            [_suspendDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
}

-(void)restartDownloadWithGameId:(NSString *)mid
{
    
}

-(void)createDownloadHttpRequest:(FZGameFile *)model
{
    NSURL *downloadURL = [NSURL URLWithString:model.downloadUrl];
    //进度条
//    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//    progressView.progress=0.0f;
    
//    model.progressView = progressView;
    
    //添加一个下载请求到队列
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:downloadURL];
    request.delegate = self;
    request.downloadProgressDelegate = self;
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setUserInfo:[NSDictionary dictionaryWithObject:model.iD forKey:@"id"]];
    [request setDownloadDestinationPath:[[self getDownloadPath] stringByAppendingPathComponent:model.fileName]];
    [request setTemporaryFileDownloadPath:[[self getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",model.fileName]]];
    [request setAllowResumeForFileDownloads:YES];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request setTimeOutSeconds:60];
    [queue addOperation:request];
    
    model.state = downloading;
    [_downloadingQueue addObject:model];
}

-(void)dealloc
{
    [queue setDelegate:nil];
    [queue cancelAllOperations];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *userinfo =  request.userInfo;
    [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
            NSLog(@"%@下载完毕", model.name);
            model.state = over;
            [_overDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
    
    //自动启动队列中等待的下载
    if ([queue requestsCount] < _maxDownLoad) {
        FZGameFile *model = [_waitDownloadQueue firstObject];
        [self createDownloadHttpRequest:model];
        [_waitDownloadQueue removeObject:model];
        [_downloadingQueue addObject:model];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed");
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    NSDictionary *userinfo =  request.userInfo;
     [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         FZGameFile *model = obj;
         if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
             model.fileSize = [NSString stringWithFormat:@"%lld",request.contentLength];
             *stop = YES;
         }
     }];
}

#pragma mark ASIProgressDelegate
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSDictionary *userinfo =  request.userInfo;
    NSString *gameid = [userinfo objectForKey:@"id"];
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *gamefile = obj;
        if ([gamefile.iD isEqualToString:gameid]) {
//            gamefile.receviedSize = [[NSString stringWithFormat:@"%lld",[gamefile.receviedSize longLongValue]+bytes] ];
            gamefile.receviedSize =  [NSString stringWithFormat:@"%lld",[gamefile.receviedSize longLongValue]+bytes];
            NSLog(@"filesize:%@, receviedSize:%@",gamefile.fileSize,gamefile.receviedSize);
            *stop = YES;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil];
    
//    if (_fzDownloadDelegate != nil && [_fzDownloadDelegate respondsToSelector:@selector(refreshDownloadCallBack)]) {
//        [self.fzDownloadDelegate refreshDownloadCallBack];
//    }
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



@end