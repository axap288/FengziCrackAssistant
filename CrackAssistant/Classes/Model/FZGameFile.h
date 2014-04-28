//
//  FZGameFile.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import <Foundation/Foundation.h>
#import "FZGame.h"

//下载状态
typedef enum {
    downloading=0,
    waitting =1,
    suspend = 2,
    over=3
}downloadState;

@interface FZGameFile : FZGame<NSCoding>

@property (strong,nonatomic) NSString *fileName;//文件名
@property (strong,nonatomic) NSString *crackFileUrl; //此游戏的破解下载地址
@property (strong,nonatomic) NSString *downloadUrl;//下载URL
@property (strong,nonatomic) NSString *fileSize;   //文件实际大小
@property (strong,nonatomic) NSString *receviedSize;//已下载的大小
@property (strong,nonatomic) NSString *last_receviedSize;//上次已下载的大小
@property (strong,nonatomic) UIProgressView *progressview;
@property (assign) downloadState state;

@end
