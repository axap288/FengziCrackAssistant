//
//  FZCrackGameInstaller.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-26.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZCrackGameInstaller.h"
#import "ASIHTTPRequest.h"


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
 *  @param package 包名
 *
 *  @return
 */
-(BOOL)backupSourceAppFilesWithPackage:(NSString *)package;



@end

@implementation FZCrackGameInstaller
{
    NSDictionary *allAppPackage;
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

-(BOOL)installCrackFile:(NSString *)savefileUrl toAPP:(NSString *)appPackage
{
    BOOL success = NO;
    
    NSString* filePath = [self downloadFile:savefileUrl];
    NSLog(@"savefilePath:%@",filePath);
    return success;
}

-(BOOL)installCrackGameFile:(NSURL*)localGamefile
{
    BOOL success = NO;
    
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

-(BOOL)backupSourceAppFilesWithPackage:(NSString *)package
{
    BOOL success = NO;
    __block NSString *appPath;
    
    if (allAppPackage == nil) {
        [self scanAllUserInstallAPP];
    }
    
    [[allAppPackage allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *p = obj;
        if ([p isEqualToString:package]) {
            NSDictionary *dic = [allAppPackage objectForKey:package];
            appPath = [dic objectForKey:@"Path"];
            *stop = YES;
        }
    }];
    
    return success;
}

-(void)scanAllUserInstallAPP
{
    allAppPackage = [NSDictionary dictionary];
    
    NSString *plistPath = @"/var/mobile/Library/Caches/com.apple.mobile.installation.plist";
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (!dic) {
        NSLog(@"dic is nil");
    }else{
        allAppPackage = [dic objectForKey:@"User"];
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
