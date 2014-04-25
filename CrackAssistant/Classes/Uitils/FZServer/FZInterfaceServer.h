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
/*
- (NSString *)userLogin:(NSString *)userName
               userPass:(NSString *)password
       withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
       withFailureBlock:(WSInterfaceFailureBlock)failureBlock;
*/

/**
 *  本地游戏存档列表接口
 *
 *  @param page
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return request的Hash值
 */
-(NSString *)loadUsefulGameSaveFile:(NSDictionary *)allLocalPackage
             withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
             withFailureBlock:(WSInterfaceFailureBlock)failureBlock;
/**
 *  游戏栏目列表
 *
 *  @param cid          类别id
 *  @param pageNum      页数
 *  @param successBlock <#successBlock description#>
 *  @param failureBlock <#failureBlock description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)loadGamesListWithCatgoryId:(NSString *)cid withPage:(NSString *)pageNum
                 withSuccessBlock:(WSInterfaceSuccessBlock)successBlock
                 withFailureBlock:(WSInterfaceFailureBlock)failureBlock;



@end
