//
//  FZInterfaceServer.m
//  CrackAssistant
//
//  Created by enalex on 13-7-3.
//
//

#import "FZInterfaceServer.h"
#import "FZBaseServerRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "FZNetWorkReachability.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
// #import "WSDataBaseUtils.h"

#define kServerPaht @"http://www.fengzigame.com/index.php"

@interface FZInterfaceServer ()

/**
 @function  调用BaseRequest发送请求，保存block
 @param     paraDic     请求参数字典
 @param     uriString   业务接口的URI
 @result
 */
- (NSString *)sendBaseRequestWithPara:(id)para
                            uriString:(NSString *)uriString
                         successBlock:(WSInterfaceSuccessBlock)success
                         failureBlock:(WSInterfaceFailureBlock)failure;

@end

@implementation FZInterfaceServer

- (id)init
{
    self = [super init];
    if (self) {
    
        self.successBlockCacheDic = [NSMutableDictionary dictionary];
        self.failureBlockCacheDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

// 获取接口服务类单例
+ (FZInterfaceServer *)getShareInstance
{
    static FZInterfaceServer *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

/**
 @function  请求参数设定
 @param     para    请求的参数,Dictionary形式
 @param     baseRequest     要设定参数的请求
 */
- (void)setRequestParameter:(id)para
                baseRequest:(FZBaseServerRequest *)baseRequest
                 requestUri:(NSString *)uri
{
    NSDictionary *paraDic = (NSDictionary *)para;
    
    for (NSString *key in [paraDic allKeys]) {
        [baseRequest.formRequest setPostValue:[paraDic objectForKey:key] forKey:key];
    }
}

/**
 @function 调用BaseRequest发送请求，保存block
 @param     paraDic     请求参数字典
 @param     uriString   业务接口的URI
 @result
 */
- (NSString *)sendBaseRequestWithPara:(id)para
                            uriString:(NSString *)uriString
                         successBlock:(WSInterfaceSuccessBlock)success
                         failureBlock:(WSInterfaceFailureBlock)failure
{
    
    // 当前网络不存在的场合，弹出提示，逻辑结束。
    if (![FZNetWorkReachability networkAvailable]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"alertMessageNetworkUnavailable", @"")];
        failure(NSLocalizedString(@"alertMessageNetworkUnavailable", @""));
        return nil;
    }
        
    // Block Copy
    WSInterfaceSuccessBlock successBlock = [success copy];
    WSInterfaceFailureBlock failureBlock = [failure copy];
    
    
    __block FZBaseServerRequest *request = [[FZBaseServerRequest alloc]
                                            initWithUrl:[NSString stringWithFormat:@"%@?%@", kServerPaht, uriString]];
    
    // 用Request的Hash值当KEY来存储该请求的BLock
    [_successBlockCacheDic setObject:successBlock forKey:[NSString stringWithFormat:@"%d", request.hash]];
    [_failureBlockCacheDic setObject:failureBlock forKey:[NSString stringWithFormat:@"%d", request.hash]];
    
    // 请求参数设定
    [self setRequestParameter:para baseRequest:request requestUri:uriString];
    
    // 添加网络请求视图

    
    [request startAsyncRequest:^(NSString *responseString) {

        // 消除网络请求层
        
        // 根据request的Hash值，获取该request的成功block
        WSInterfaceSuccessBlock successCallBackBlock = [_successBlockCacheDic objectForKey:[NSString stringWithFormat:@"%d", [request hash]]];
        
        if (successCallBackBlock) {
            successCallBackBlock(responseString);
        }
        
        // 从缓存中清除该request的block
        [self cancleBaseRequestBlock:[NSString stringWithFormat:@"%d", [request hash]]];
        
        // __block变量，在ARC场合在block内会被自动retain，所以需要释放内存。
        request = nil;
        
    } failureBlock:^(NSString *errorMessage, NSString *errorCode) {
        
        // 消除网络请求层

        // 根据request的Hash值，获取该request的失败block
        WSInterfaceFailureBlock failureCallBackBlock = [_failureBlockCacheDic
                                                        objectForKey:[NSString stringWithFormat:@"%d",
                                                                      [request hash]]];
        if (failureCallBackBlock) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
            failureCallBackBlock(errorMessage);
        }
        
        // 从缓存中清除该request的block
        [self cancleBaseRequestBlock:[NSString stringWithFormat:@"%d", [request hash]]];
        
        // __block变量，在ARC场合在block内会被自动retain，所以需要释放内存。
        request = nil;
    }];
    
    return [NSString stringWithFormat:@"%d", [request hash]];
}

/**
 @function  取消BaseRequest的block回调
 @param     request的Hash值
 @result
 */
- (void)cancleBaseRequestBlock:(NSString *)requestHash
{
    @synchronized(self)
    {
        if (requestHash) {
            [_successBlockCacheDic removeObjectForKey:requestHash];
            [_failureBlockCacheDic removeObjectForKey:requestHash];
        }
    }
}

#pragma mark -
#pragma mark API
/**
 @function  用户登录
 @param     userName   用户账号
 @param     password   用户密码
 @result    request的Hash值
 */
/*
- (NSString *)userLogin:(NSString *)userName
               userPass:(NSString *)password
       withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
       withFailureBlock:(WSInterfaceFailureBlock)failureBlock

{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userName forKey:@"username"];
    [paraDic setObject:password forKey:@"password"];
    
    return [self sendBaseRequestWithPara:paraDic
                        uriString:@"app/login.aspx"
                     successBlock:successBlock
                     failureBlock:failureBlock];
}
 */

-(NSString *)loadUsefulGameSaveFile:(NSDictionary *)allLocalPackage
                   withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
                   withFailureBlock:(WSInterfaceFailureBlock)failureBlock;
{
    
    NSString *jsonStr = [allLocalPackage JSONString];
    NSLog(@"jsonStr:%@",jsonStr);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:jsonStr forKey:@"data"];
    
    return [self sendBaseRequestWithPara:paraDic
                               uriString:@"m=ios&c=index&a=ican"
                            successBlock:successBlock
                            failureBlock:failureBlock];
}

-(NSString *)loadGamesListWithCatgoryId:(NSString *)cid withPage:(NSString *)pageNum
                       withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
                       withFailureBlock:(WSInterfaceFailureBlock)failureBlock
{
    NSScanner *scan1 =  [NSScanner scannerWithString:cid];
    NSScanner *scan2 = [NSScanner scannerWithString:pageNum];
    int val;
    if ([scan1 scanInt:&val] &&[scan1 isAtEnd]) {
        
    }
    
    if ([scan2 scanInt:&val] &&[scan2 isAtEnd]) {
        
    }
    
    
    
    NSString *parameterStr = [NSString stringWithFormat:@"m=ios&c=index&a=glists&catid=%@&page=%@",cid,pageNum];
    return [self sendBaseRequestWithPara:[NSMutableDictionary dictionary]
                               uriString:parameterStr
                            successBlock:successBlock
                            failureBlock:failureBlock];
}

/**
 *  首页banner图片列表接口
 *
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return request的Hash值
 */
-(NSString *)loadHomeBannerWithSuccessBlock:(WSInterfaceSuccessBlock)successBlock
                           withFailureBlock:(WSInterfaceFailureBlock)failureBlock
{
    NSString *parameterStr = @"m=ios&c=index&a=banner_index";
    return [self sendBaseRequestWithPara:[NSMutableDictionary dictionary]
                               uriString:parameterStr
                            successBlock:successBlock
                            failureBlock:failureBlock];
}

/**
 *  首页游戏推荐列表接口
 *
 *  @param pageNum      页数
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return request的Hash值
 */
-(NSString *)loadHomeGameListWithPage:(NSString *)pageNum
                     WithSuccessBlock:(WSInterfaceSuccessBlock)successBlock
                     withFailureBlock:(WSInterfaceFailureBlock)failureBlock
{

    NSString *parameterStr = [NSString stringWithFormat:@"m=ios&c=index&a=gindex&page=%@", pageNum];
    return [self sendBaseRequestWithPara:[NSMutableDictionary dictionary]
                               uriString:parameterStr
                            successBlock:successBlock
                            failureBlock:failureBlock];
}

@end
