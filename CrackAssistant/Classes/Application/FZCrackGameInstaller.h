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
 *  安装本地已下载的APP
 *
 *  @param localGamefile <#localGamefile description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)installCrackGameFile:(NSURL*)localGamefile;




@end
