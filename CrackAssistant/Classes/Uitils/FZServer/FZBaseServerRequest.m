//
//  FZBaseServerRequest.m
//  CrackAssistant
//
//  Created by enalex on 13-7-2.
//  
//

#import "FZBaseServerRequest.h"
#import "JSONKit.h"
#import "FZInterfaceServer.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"

#define kRequestTimeOut 20

static NSString *SessionTimeOut = @"sessionTimeOut";

@interface FZBaseServerRequest ()

@end

@implementation FZBaseServerRequest

- (id)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if (self) {

        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // 创建请求
        _formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        // 请求方法
        [_formRequest setRequestMethod:@"POST"];
        // 超时时间
        [_formRequest setTimeOutSeconds:kRequestTimeOut];
        // 超时请求次数
        [_formRequest setNumberOfTimesToRetryOnTimeout:0];    
    }
    return self;
}

// 启动异步网络加载
- (void)startAsyncRequest:(WSBaseServerSuccessBlock)serverSuccessBlock
            failureBlock:(WSBaseServerFailureBlock)serverFailureBlock
{
    // Block Copy
    _baseServerSuccessBlock = [serverSuccessBlock copy];
    _baseServerFailureBlock = [serverFailureBlock copy];
    
    
    // 避免对象循环引用，在ARC状态下__block还是会把request做retain处理，应该使用__weak，
    // 但是在4.3环境下没有__weak，所以沿用__block，但是在block内把request设定成nil。
    __block ASIFormDataRequest *blockRequest = _formRequest;
    __block WSBaseServerSuccessBlock successBlock = _baseServerSuccessBlock;
    __block WSBaseServerFailureBlock failureBlock = _baseServerFailureBlock;
    
    // 加载成功处理
    [_formRequest setCompletionBlock:^{

        // 返回数据做UTF-8转码
        NSString *responseString = [[NSString alloc] initWithData:[blockRequest responseData] encoding:NSUTF8StringEncoding];
        // NSLog(@"%@", responseString);
        
        // 请求数据正常
        if (successBlock) {
            successBlock(responseString);
        }
        
        blockRequest = nil;
    }];
    
    // 加载失败处理
    [_formRequest setFailedBlock:^{

        if (failureBlock) {
            failureBlock(NSLocalizedString(@"alertMessageSystemError", @""), @"");
            NSLog(@"%@", blockRequest.error.userInfo);
        }
        blockRequest = nil;
    }];
    
    // 启动异步网络请求
    [_formRequest startAsynchronous];
}
@end
