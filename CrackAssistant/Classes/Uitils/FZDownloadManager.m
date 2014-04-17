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
        _maxDownLoad = 1;//默认只有一个下载
        _waitDownloadQueue = [NSMutableArray array];
        _overDownloadQueue = [NSMutableArray array];
        _downloadingQueue = [NSMutableArray array];
        _suspendDownloadQueue = [NSMutableArray array];
        
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
        
//        [self performSelectorInBackground:@selector(startDonwloadTimer) withObject:nil];
        [self startDonwloadTimer];
    }
    return self;
}

-(void)startDonwloadTimer
{
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(donwloadEngine) userInfo:nil repeats:YES];
    [timer1 fire];
}

-(void)donwloadEngine
{
    if ([_waitDownloadQueue count] != 0) {
        //保存待移除元素的临时数组
        NSMutableArray *temp = [NSMutableArray array];
        [_waitDownloadQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"request count:%d",[queue requestsCount]);
            if ([queue requestsCount] < _maxDownLoad) {
                FZGameFile *waittingGamefile = obj;
                
                __block BOOL isAllow = YES;
                [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    FZGameFile *downloadingGamefile = obj;
                    if ([waittingGamefile.iD isEqualToString:downloadingGamefile.iD]) {
                        NSLog(@"已存在相同下载");
                        isAllow = NO;
//                        *stop = YES;
                    }
                }];
                
                if (isAllow) {
                    [self createDownloadHttpRequest:waittingGamefile];
                    [_downloadingQueue addObject:waittingGamefile];
                    [temp addObject:waittingGamefile];
                }
  
            }
        }];
        [_waitDownloadQueue removeObjectsInArray:temp];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDownloadNotification object:nil];
}

-(void)createDownloadHttpRequest:(FZGameFile *)model
{
    NSURL *downloadURL = [NSURL URLWithString:model.downloadUrl];
    
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
}



-(void)addDownloadToList:(FZGameFile *)model
{
    [_waitDownloadQueue addObject:model];
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
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:mid]) {
            [_suspendDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
    
}

-(void)restartDownloadWithGameId:(NSString *)mid
{
    [_suspendDownloadQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:mid]) {
            [_waitDownloadQueue addObject:model];
            [_suspendDownloadQueue removeObject:model];
            *stop = YES;
        }
    }];
    
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
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
            NSLog(@"%@下载完毕", model.name);
            model.state = over;
            [_overDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *userinfo =  request.userInfo;
    [_downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameFile *model = obj;
        if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
            NSLog(@"%@下载失败", model.name);
            [_suspendDownloadQueue addObject:model];
            [_downloadingQueue removeObject:model];
            *stop = YES;
        }
    }];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    NSDictionary *userinfo =  request.userInfo;
     [self.downloadingQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         FZGameFile *model = obj;
         if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
             if (!model.fileSize) {
                 model.fileSize = [NSString stringWithFormat:@"%lld",request.contentLength];
             }
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
            gamefile.receviedSize =  [NSString stringWithFormat:@"%lld",[gamefile.receviedSize longLongValue]+bytes];
            *stop = YES;
        }
    }];
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
