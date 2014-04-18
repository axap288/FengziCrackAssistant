//
//  FZGameFile.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import <Foundation/Foundation.h>
#import "FZGame.h"


@interface FZGameFile : FZGame<NSCoding>

@property (strong,nonatomic) NSString *fileName;//文件名
@property (strong,nonatomic) NSString *downloadUrl;//下载URL
@property (strong,nonatomic) NSString *fileSize;   //文件实际大小
@property (strong,nonatomic) NSString *receviedSize;//已下载的大小

@end
