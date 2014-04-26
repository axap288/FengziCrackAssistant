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

+(NSString *)downloadFile:(NSString *)fileURL;

@end

@implementation FZCrackGameInstaller

+(BOOL)installCrackFile:(NSString *)savefileUrl toAPP:(NSString *)appPackage
{
    BOOL success = NO;
    
    NSString* filePath = [FZCrackGameInstaller downloadFile:savefileUrl];
    NSLog(@"savefilePath:%@",filePath);
    return success;
}

+(BOOL)installCrackGameFile:(NSURL*)localGamefile
{
    BOOL success = NO;
    
    return success;
}

+(NSString *)downloadFile:(NSString *)fileURL
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




@end
