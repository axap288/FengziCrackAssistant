//
//  FZCrackGameInstaller.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-26.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FZCrackGameInstallDelegate <NSObject>

//破解成功
-(void)crackSuccess:(NSString *)Identifier;
//破解失败
-(void)crackFailure:(NSString *)Identifier;

@end

@interface FZCrackGameInstaller : NSObject

@property(assign) id<FZCrackGameInstallDelegate> delegate;

+(FZCrackGameInstaller *)getShareInstance;


/**
 *  将服务器的破解文件安装到目标APP中
 *
 *  @param savefileUrl
 *  @param appPackage
 *
 *  @return
 */
-(BOOL)installCrackFile:(NSString *)savefileUrl toAPP:(NSString *)Identifier;
/**
 *  恢复操作
 *
 *  @param appPackage
 *
 *  @return
 */
-(BOOL)recoverCrackByIdentifier:(NSString *)Identifier;
/**
 *  安装本地已下载的APP
 *
 *  @param localGamefile <#localGamefile description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)installCrackGameFile:(NSURL*)localGamefile;
/**
 * 判断是否破结果
 *
 *  @param appPackage 包名
 *
 *  @return YES:已破解
 */
-(BOOL)checkIsCrackByIdentifier:(NSString *)Identifier;
/**
 *  启动应用
 *
 *  @param packageName
 */
-(void)launchAppByIdentifier:(NSString *)Identifier;





@end
