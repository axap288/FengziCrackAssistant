//
//  FZBaseServerRequest.h
//  CrackAssistant
//
//  Created by enalex on 13-7-2.
//  
//

#import <Foundation/Foundation.h>

@class ASIFormDataRequest;

typedef void (^WSBaseServerSuccessBlock)(NSString *responseString);
typedef void (^WSBaseServerFailureBlock)(NSString *errorMessage, NSString *errorCode);

@interface FZBaseServerRequest : NSObject

@property (strong, nonatomic) ASIFormDataRequest *formRequest;

@property (copy, nonatomic) WSBaseServerSuccessBlock baseServerSuccessBlock;
@property (copy, nonatomic) WSBaseServerFailureBlock baseServerFailureBlock;

- (id)initWithUrl:(NSString *)urlString;

// 启动异步网络加载
- (void)startAsyncRequest:(WSBaseServerSuccessBlock)serverSuccessBlock
            failureBlock:(WSBaseServerFailureBlock)serverFailureBlock;

@end
