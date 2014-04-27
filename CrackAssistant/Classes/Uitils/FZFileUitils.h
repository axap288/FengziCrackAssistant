//
//  FZFileUitils
//
//  Created by LN on 13-9-17.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FZFileUitils : NSObject
/**
 *  字符串内容写入到指定文件
 *
 *  @param content  字符串内容
 *  @param fileName 文件名（document目录下）
 */
+(void)wirteContent:(NSString *)content toFIle:(NSString *)fileName;
/**
 *  获取一个文件的全部路径
 *
 *  @param filename 文件名
 *
 *  @return
 */
+(NSString *)getFullPath:(NSString *)filename ;
/**
 *  删除document下的某个文件
 *
 *  @param filename 文件名
 *
 *  @return
 */
+(BOOL)removeFile:(NSString *)filename;
/**
 *  删除指定路径的文件
 *
 *  @param filepath 路径
 *
 *  @return
 */
+(BOOL)removeFileWithFilePath:(NSString *)filepath;
/**
 *  读取指定路径下的文本文件内容
 *
 *  @param filePath
 *
 *  @return
 */
+(NSString *)readContentFromFile:(NSString *)filePath;
/**
 *  移动文件到指定的文件夹
 *
 *  @param sourcefileName 原路径
 *  @param dirName        目标路径
 */
+(void)moveFile:(NSString *)sourcefileName toDir:(NSString *)dirName;

//+(NSArray *)getAllZipFiles;
/**
 *  判断指定的文件名是否为目录
 *
 *  @param dirName <#dirName description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isEmptyDir:(NSString *)dirName;

@end
