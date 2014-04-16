//
//  FZInterfaceServer.h
//  CrackAssistant
//
//  Created by enalex on 13-7-3.
//  
//

#import <Foundation/Foundation.h>

typedef void(^WSInterfaceSuccessBlock)(id responseObject);
typedef void(^WSInterfaceFailureBlock)(NSString *errorMessage);

@interface FZInterfaceServer : NSObject

@property (nonatomic, strong) NSMutableDictionary *successBlockCacheDic;
@property (nonatomic, strong) NSMutableDictionary *failureBlockCacheDic;

// 获取接口服务类单例
+ (FZInterfaceServer *)getShareInstance;

/**
 @function  取消BaseRequest的block回调
 @param     request的Hash值
 @result
 */
- (void)cancleBaseRequestBlock:(NSString *)requestHash;

#pragma mark -
#pragma mark API
/**
 @function  用户登录
 @param     userName   用户账号
 @param     password   用户密码
 @result    request的Hash值
 */
- (NSString *)userLogin:(NSString *)userName
               userPass:(NSString *)password
       withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
       withFailureBlock:(WSInterfaceFailureBlock)failureBlock;

@end