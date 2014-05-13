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

//
typedef enum{
    install=0,//app未安装，对应前端"安装"
    reinstall=1,//app已安装，对应前端"重装"
    update=2,//app可更新，对应前端"更新"
    indownload=3, //app下载中
    download=4//app未下载,对应前端"下载"
}installState;

@interface FZGameFile : FZGame<NSCoding>

@property (strong,nonatomic) NSString *fileName;//文件名
@property (strong,nonatomic) NSString *crackFileUrl; //此游戏的破解下载地址
@property (strong,nonatomic) NSString *normalDownloadUrl;//普通版下载URL
@property (strong,nonatomic) NSString *crackDownloadUrl;//破解版下载URL
@property (strong,nonatomic) NSString *downloadUrl;//实际下载中的URL
@property (strong,nonatomic) NSString *fileSize;   //文件实际大小
@property (strong,nonatomic) NSString *receviedSize;//已下载的大小
@property (strong,nonatomic) NSString *last_receviedSize;//上次已下载的大小
@property (strong,nonatomic) UIProgressView *progressview;
@property (assign) downloadState downloadState;//下载状态
@property (assign) installState installState;//安装状态

@end
