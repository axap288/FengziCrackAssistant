//
//  FZCrackGameInstaller.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-26.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#include <stdlib.h>
#include <sys/sysctl.h>
#import <dlfcn.h>

#import "FZCrackGameInstaller.h"
#import "FZFileUitils.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"
#import  "SSZipArchive.h"
//#import "SBApplication.h"

#define SPRINGBOARDPATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define InStallationPlistPath @"/var/mobile/Library/Caches/com.apple.mobile.installation.plist"

#define backupZipFile @"FzgameBackup.zip"



@interface FZCrackGameInstaller(private)


/**
 *  是否越狱
 *
 *  @return YES：越狱
 */
-(BOOL)isJailbroken;
/**
 *  备份原始文件
 *
 *  @param Identifier
 *
 *  @return
 */
-(BOOL)backupSourceAppFilesByIdentifier:(NSString *)Identifier;
/**
 *  杀掉一个运行的APP
 *
 *  @param Identifier
 *
 *  @return
 */
-(void)killAppProcessByIdentifier:(NSString *)Identifier;
/**
 *  根据包名获取到进程ID
 *
 *  @param identifi
 *
 *  @return 进程id
 */
-(NSString *)getProcessIDByIdentifier:(NSString *)Identifier;




@end

@implementation FZCrackGameInstaller
{
    NSDictionary *allAppIdentifier;
}

+(FZCrackGameInstaller *)getShareInstance
{
    static FZCrackGameInstaller *shareInstance;
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
        
    }
    return self;
}

-(BOOL)installCrackFile:(NSString *)savefileUrl toAPP:(NSString *)Identifier
{
    BOOL success = NO;
    
    //判断是否有此目录
    NSString *destinationPath = [self getAppHomePathByIdentifier:Identifier];
    BOOL result = [FZFileUitils fileExisit:destinationPath];
    if (!result) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(crackFailure:)]) {
            [_delegate crackFailure:Identifier];
        }
        return NO;
    }

    success = [self backupSourceAppFilesByIdentifier:Identifier];
    
    if (success) {
        
        //先杀掉运行中的游戏进程
        [self killAppProcessByIdentifier:Identifier];
        
        //破解操作
        NSString* zipfilePath = [self downloadFile:savefileUrl];
        NSLog(@"zipfilePath:%@",zipfilePath);


        BOOL unzipsuccess = [SSZipArchive unzipFileAtPath:zipfilePath toDestination:destinationPath];
        if (unzipsuccess) {
            NSLog(@"破解成功");
            if (_delegate != nil && [_delegate respondsToSelector:@selector(crackSuccess:)]) {
                [_delegate crackSuccess:Identifier];
            }
            success = YES;
        }else{
            NSLog(@"破解失败");
            if (_delegate != nil && [_delegate respondsToSelector:@selector(crackFailure:)]) {
                [_delegate crackFailure:Identifier];
            }

            success = NO;
        }
        
    }else{
        NSLog(@"备份失败了");
    }
    return success;
}

-(BOOL)recoverCrackByIdentifier:(NSString *)Identifier
{
    __block BOOL success = YES;
    BOOL iscrack = [self checkIsCrackByIdentifier:Identifier];
    if (iscrack) {
        //先杀掉运行中的游戏进程
        [self killAppProcessByIdentifier:Identifier];
        
        
        
        NSString *destinationPath = [self getAppHomePathByIdentifier:Identifier];
        NSString *backupzipPath = [destinationPath stringByAppendingPathComponent:backupZipFile];
        
        
        NSArray *backupDirName = @[@"Documents",@"Library"];
        [backupDirName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *needRemovePath = [destinationPath stringByAppendingPathComponent:obj];
            BOOL deleSuccess = [FZFileUitils removeFileWithFilePath:needRemovePath];
            if (!deleSuccess) {
                success = NO;
                *stop = YES;
            }
        }];
        
        
        if (success) {
            NSLog(@"删除成功");
            
            BOOL unzipsuccess = [SSZipArchive unzipFileAtPath:backupzipPath toDestination:destinationPath];
            if (unzipsuccess) {
                NSLog(@"恢复成功");
                //最后删除备份文件
                [FZFileUitils removeFileWithFilePath:backupzipPath];
            }else{
                NSLog(@"恢复失败");
            }
            success = unzipsuccess;
            
        }else{
            NSLog(@"删除失败");
        }
        
    }
    return success;
}



-(BOOL)installCrackGameFile:(NSString*)localGamefile
{
    BOOL success = NO;
    
    //首先判断安装文件是否存在
    NSString *gamefilePath =   [FZFileUitils getFullPath:localGamefile];
    NSLog(@"gamefilePath:%@",gamefilePath);
    if (![FZFileUitils fileExisit:gamefilePath]) {
        return success;
    }
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use) = dlsym(lib, "MobileInstallationInstall");
        int ret = MobileInstallationInstall(gamefilePath, [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"], nil, gamefilePath);
        dlclose(lib);
        
        NSLog(@"ret:%d",ret);
        if (ret == 0) {
            success = YES;
        }
    }
    return success;
}

-(NSString *)downloadFile:(NSString *)fileURL
{
    
    NSString *tempDir = NSTemporaryDirectory();
    NSString *destinationPath = [tempDir stringByAppendingPathComponent:[fileURL lastPathComponent]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fileURL]];
    [request setDownloadDestinationPath:destinationPath];
    [request startSynchronous];
    if ([request isFinished]) {
        NSLog(@"下载完成");
    }
    return destinationPath;
}

-(NSString *)getAppHomePathByIdentifier:(NSString *)Identifier
{
    if (allAppIdentifier == nil) {
        [self scanAllUserInstallAPP];
    }
    
    __block NSString *appHomePath = nil;
    //根据包名查找app的绝对路径
    [[allAppIdentifier allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *p = obj;
        if ([p isEqualToString:Identifier]) {
            NSDictionary *dic = [allAppIdentifier objectForKey:Identifier];
            NSString *appPath = [dic objectForKey:@"Path"];
            //转向上一级目录
            appHomePath = [appPath stringByDeletingLastPathComponent];
            *stop = YES;
        }
    }];
    return appHomePath;
}

-(NSString *)getAppVersionByIdentifier:(NSString *)Identifier
{
    if (allAppIdentifier == nil) {
        [self scanAllUserInstallAPP];
    }
    
    __block NSString *appversion = nil;
    [[allAppIdentifier allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *p = obj;
        if ([p isEqualToString:Identifier]) {
            NSDictionary *dic = [allAppIdentifier objectForKey:Identifier];
            appversion = [dic objectForKey:@"appVersion"];
            *stop = YES;
        }
    }];
    return appversion;
}

-(BOOL)backupSourceAppFilesByIdentifier:(NSString *)Identifier
{
    __block BOOL success = YES;
    
    NSString *appHomePath = [self getAppHomePathByIdentifier:Identifier];
    
    if (appHomePath) {
        //需要备份到的目录
        NSString *backupStorePath = [appHomePath stringByAppendingPathComponent:@"FzgameBackup"];
        NSString *backupZipFilePath = [appHomePath stringByAppendingPathComponent:backupZipFile];
        
        [FZFileUitils makeDirIfNotExist:backupStorePath];
        NSLog(@"backupStorePath:%@",backupStorePath);
        
        //需要备份的文件夹
        NSArray *backupDirName = @[@"Documents",@"Library"];
        [backupDirName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *needBackupPath = [appHomePath stringByAppendingPathComponent:obj];
            NSLog(@"needBackupPath:%@",needBackupPath);
            BOOL copySuccess =  [FZFileUitils copyFile:needBackupPath toDir:[backupStorePath stringByAppendingPathComponent:obj]];
            if (!copySuccess) {
                success = NO;
                *stop = YES;
            }
        }];
        
        if (success) {
            //备份为zip包
            BOOL zipSuccess =  [SSZipArchive createZipFileAtPath:backupZipFilePath withContentsOfDirectory:backupStorePath];
            if(zipSuccess)
            {
                NSLog(@"备份成功!");
            }else{
                NSLog(@"备份失败!");
                success = NO;
            }
        }
        
        //删除备份文件夹
        [FZFileUitils removeFileWithFilePath:backupStorePath];
    }
    
    return success;
}

-(void)scanAllUserInstallAPP
{
    allAppIdentifier = [NSDictionary dictionary];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:InStallationPlistPath];
    if (!dic) {
        NSLog(@"dic is nil");
    }else{
        allAppIdentifier = [dic objectForKey:@"User"];
        /*
        for (NSString *package in [appPackage allKeys]) {
            
            NSDictionary *dic = [appPackage objectForKey:package];
            NSString *appname = [dic objectForKey:@"CFBundleDisplayName"];
            NSString *appVersion = [dic objectForKey:@"CFBundleVersion"];
            NSString *path = [dic objectForKey:@"Path"];
            NSLog(@"AppName:%@",appname);
            NSLog(@"Package:%@",package);
            NSLog(@"App Version:%@",appVersion);
            NSLog(@"APP Path:%@",path);
            NSLog(@"==============================");
            //        NSLog(@"Package:%@",package);
        }
         */
    }
}

-(BOOL)checkIsCrackByIdentifier:(NSString *)Identifier
{
    if (![self isJailbroken]) {
        return NO;
    }
    //根据备份文件是否存在判断是否破解过
    NSString *appHomePath = [self getAppHomePathByIdentifier:Identifier];
    NSString *backupzipPath = [appHomePath stringByAppendingPathComponent:backupZipFile];
    BOOL result = [FZFileUitils fileExisit:backupzipPath];
    return result;
}

-(void)killAppProcessByIdentifier:(NSString *)Identifier
{
    NSString *appProcessId = [self getProcessIDByIdentifier:Identifier];
    if (appProcessId) {
        NSString *commandStr = [NSString stringWithFormat:@"kill %@",appProcessId];
        const char *command = [commandStr cStringUsingEncoding:NSUTF8StringEncoding];
        system(command);
    }
}

-(void)launchAppByIdentifier:(NSString *)Identifier
{
    NSLog(@"Identifier:%@",Identifier);
    void *sbserv = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
     int (*SBSLaunchApplicationWithIdentifier)(CFStringRef identifier, Boolean suspended) = dlsym(sbserv, "SBSLaunchApplicationWithIdentifier");
     SBSLaunchApplicationWithIdentifier((__bridge CFStringRef)Identifier, FALSE);
    
    dlclose(sbserv);
}


-(NSString *)getProcessIDByIdentifier:(NSString *)Identifier
{
    mach_port_t *port;
    void *sbserv = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(sbserv, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();
    
    void* (*SBDisplayIdentifierForPID)(mach_port_t* port, int pid,char * result) = dlsym(sbserv, "SBDisplayIdentifierForPID");
    
    //获取现有进程
    NSString * processid = nil;
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    //    int st;
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess){
            if (process){
                free(process);
            }
            return nil;
        }
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess){
                for (int i = nprocess - 1; i >= 0; i--){
                    char appid[256];
                    memset(appid,sizeof(appid),0);
                    int intID;
                    intID=process[i].kp_proc.p_pid;
                    SBDisplayIdentifierForPID(port,intID,appid);
                    NSString * appId=[NSString stringWithUTF8String:appid];
                    if ([Identifier isEqualToString:appId]) {
                        processid = [NSString stringWithFormat:@"%d",process[i].kp_proc.p_pid];
                        break;
                    }
                }
                free(process);
            }
        }
    }
    dlclose(sbserv);
    NSLog(@"processid:%@",processid);
    return processid;
}


-(BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}






@end
