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

+(BOOL)installCrackSaveFile:(NSURL*)savefileUrl toAPP:(NSString *)appPackage
{
    BOOL success = NO;
    
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
    return destinationPath;
}


@end
