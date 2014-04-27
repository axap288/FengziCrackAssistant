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
 *  使用绝对路径，将目标文件复制到指定的文件夹
 *
 *  @param sourcefilePath 原路径
 *  @param dirName        目标路径
 */
+(BOOL)copyFile:(NSString *)sourcefilePath toDir:(NSString *)dirPath;
/**
 *  如果目录不存在则创建一个目录
 *
 *  @param dirPath <#dirPath description#>
 */
+(void)makeDirIfNotExist:(NSString *)dirPath;

//+(NSArray *)getAllZipFiles;
/**
 *  判断指定的文件名是否为目录
 *
 *  @param dirName <#dirName description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isEmptyDir:(NSString *)dirName;

/**
 *  判断一个文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return
 */
+(BOOL)fileExisit:(NSString *)filePath;

@end
