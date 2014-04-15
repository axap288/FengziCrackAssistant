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
        _downloadlist = [NSMutableArray array];
        
        //设置网络请求队列
        ASINetworkQueue *myqueue = [[ASINetworkQueue alloc] init];
        [myqueue setShowAccurateProgress:YES];
        [myqueue go];
        queue = myqueue;
    }
    return self;
}

-(void)addDownloadToList:(FZGameModel *)model
{
    
    if ([queue requestsCount] < _maxDownLoad) {
        [self createDownloadHttpRequest:model];
        model.state = downloading;
    }else{
        model.state = waitting;
    }
    [self.downloadlist addObject:model];
}

-(void)stopDownloadWithGameId:(NSString *)id
{
    
}

-(void)restartDownloadWithGameId:(NSString *)id
{
    
}

-(void)createDownloadHttpRequest:(FZGameModel *)model
{
    NSURL *downloadURL = [NSURL URLWithString:model.downloadUrl];
    //进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectZero;
    progressView.progress=0.0f;
    
    //添加一个下载请求到队列
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:downloadURL];
    request.delegate = self;
    request.downloadProgressDelegate = progressView;
    [request setUserInfo:[NSDictionary dictionaryWithObject:model.iD forKey:@"id"]];
    [request setDownloadDestinationPath:[[self getDownloadPath] stringByAppendingPathComponent:model.fileName]];
    [request setTemporaryFileDownloadPath:[[self getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",model.fileName]]];
    [queue addOperation:request];
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
    [self.downloadlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FZGameModel *model = obj;
        if ([model.iD isEqualToString:[userinfo objectForKey:@"id"]]) {
            model.state = over;
            *stop = YES;
        }
    }];
    
    //自动启动队列中等待的下载
    if ([queue requestsCount] < _maxDownLoad) {
        [self.downloadlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FZGameModel *model = obj;
            if (model.state == waitting) {
                [self createDownloadHttpRequest:model];
                model.state = downloading;
                *stop = YES;
            }
        }];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(NSString *)getDownloadPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Download"];
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
