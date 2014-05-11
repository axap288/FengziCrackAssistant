//
//  FZGameAppStateQuery.m
//  CrackAssistant
//
//  Created by LiuNian on 14-5-11.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZGameAppStateQuery.h"

@implementation FZGameAppStateQuery

+(FZGameFile *)queryStateWithObject:(FZGameFile *)fz
{
    if (fz != nil) {
        
        NSString *Identifier = fz.Identifier;
        
        FZCrackGameInstaller *installer = [FZCrackGameInstaller getShareInstance];
        NSString *appRealPath =  [installer getAppHomePathByIdentifier:Identifier];
        
        //appPath为nil表示没有在设备中发现此app，
        if (appRealPath == nil) {
            FZDownloadManager *downloadManager = [FZDownloadManager getShareInstance];
            //判断是否下载完成
            Boolean isoverDownload = [downloadManager checkifOverDownload:fz];
            if (isoverDownload) {
                fz.installState = install;
                //此处最好判断一下ipa文件确实存在的逻辑
            }else{
                //判断是否下载中
                Boolean isDownloading =  [downloadManager checkIfDownloading:fz];
                if (isDownloading) {
                    fz.installState = indownload;
                }else{
                    fz.installState = download;
                }
            }
        }else{
            //如果在设备中发现有此app,则比较版本号
            NSString *appVersionInDevice = [installer getAppVersionByIdentifier:Identifier];
            if ([FZGameAppStateQuery compareVersion:fz.version appInDevice:appVersionInDevice]) {
                //更新
                fz.installState = update;
            }else{
                //重装
                fz.installState = reinstall;
            }
        }
    }
    return fz;
}

/**
 *  版本比较大小
 *
 *  @param appVersion 目标应用的版本好
 *  @param appInDevice 安装在设备中的版本号
 *
 *  @return YES 大于设备版本
                        NO  小于或等于设备版本
 */
+(Boolean)compareVersion:(NSString *)appVersion appInDevice:(NSString *)version2
{
    NSComparisonResult result = [appVersion compare:version2 options:NSNumericSearch];
    switch (result)
    {
        case NSOrderedAscending:
        {
            return NO;
        }
            
        case NSOrderedSame:
        {
            return NO;
        }
        
        case NSOrderedDescending:
        {
            return YES;
        }
    }

}



@end
