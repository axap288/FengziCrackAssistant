//
//  FZCrackGameInstaller.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-26.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZCrackGameInstaller : NSObject



+(FZCrackGameInstaller *)getShareInstance;


/**
 *  将服务器的破解文件安装到目标APP中
 *
 *  @param savefileUrl
 *  @param appPackage
 *
 *  @return
 */
-(BOOL)installCrackFile:(NSString *)savefileUrl toAPP:(NSString *)appPackage;
/**
 *  恢复操作
 *
 *  @param appPackage
 *
 *  @return
 */
-(BOOL)recoverCrackWithPackageName:(NSString *)appPackage;
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
-(BOOL)checkIsCrackWithPackageName:(NSString *)appPackage;
/**
 *  启动应用
 *
 *  @param packageName
 */
-(void)launchAppWithPackageName:(NSString *)packageName;





@end
