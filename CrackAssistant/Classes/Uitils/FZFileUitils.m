//
//  IRFileTool.m
//  iRDataCollectorForAppStore
//
//  Created by LN on 13-9-17.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import "FZFileUitils.h"

@implementation FZFileUitils


+(void)wirteContent:(NSString *)content toFIle:(NSString *)fileName
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //目录是否存在
    /*
     NSError *error;
     BOOL isDir = YES;
     success =  [fileManager fileExistsAtPath:DOCUMENT_PATH isDirectory:&isDir];
     if (!success) {
     success = [fileManager createDirectoryAtPath:DOCUMENT_PATH withIntermediateDirectories:NO attributes:nil error:&error];
     if (!success) {
     NSLog(@"create Dir error:%@",error);
     return;
     }
     }
     
     */
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    success = [fileManager fileExistsAtPath:filePath];
    if (!success) {
        NSLog(@"===path is not found==");
        NSData *buffer = [content dataUsingEncoding:NSUTF8StringEncoding];
        [fileManager createFileAtPath:filePath contents:buffer attributes:nil];
    }else{
        NSFileHandle  *outFile;
        NSData *buffer;
        
        outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        if (outFile == nil) {
            NSLog(@"===file not found");
            return;
        }
        [outFile seekToEndOfFile];
        NSString *bs = [NSString stringWithFormat:@"%@",content];
        buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
        [outFile writeData:buffer];
        [outFile closeFile];
    }

}



+(BOOL)removeFile:(NSString *)filename
{
    NSString *filePath = [FZFileUitils getFullPath:filename];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    BOOL success = NO;
    NSError *error;
    success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success) {
        NSLog(@"ERROR:delete file error:%@",filename);
    }
    return success;
}

+(BOOL)removeFileWithFilePath:(NSString *)filepath
{
    BOOL success = NO;
    NSError *error;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    success = [fileManager removeItemAtPath:filepath error:&error];
    if (!success) {
        NSLog(@"ERROR:delete filepath error:%@",filepath);
    }
    return success;
}

+(BOOL)copyFile:(NSString *)sourcefilePath toDir:(NSString *)dirPath
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    success =  [fileManager copyItemAtPath:sourcefilePath toPath:dirPath error:&error];
    if (!success) {
        NSLog(@"copy file error:%@",[error description]);
    }
    return success;
}


+(NSString *)getFullPath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return fullPath;
}

+(NSString *)readContentFromFile:(NSString *)filePath
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *textFileContents = nil;
    
    success = [fileManager fileExistsAtPath:filePath];
    if (success) {
        textFileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"===== Error:%@====",error);
        }
    }
    return textFileContents;
}

+(void)makeDirIfNotExist:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success;

    BOOL isDir = YES;
    success =  [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!success) {
        success = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (!success) {
            NSLog(@"create Dir error:%@",error);
            return;
        }
    }
}

+(NSArray *)getAllZipFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [[fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil] pathsMatchingExtensions:[NSArray arrayWithObject:@"zip"]];
}

+(BOOL)isEmptyDir:(NSString *)dirName
{
    NSString *dirpath = [FZFileUitils getFullPath:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:dirpath error:nil];
    if (array == nil || [array count] == 0) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)fileExisit:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:filePath];
    return isExists;
}

@end
