//
//  FZGameAppStateQuery.h
//  CrackAssistant
//
//  Created by LiuNian on 14-5-11.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZGameFile.h"
#import "FZCrackGameInstaller.h"
#import "FZDownloadManager.h"

/**
 *  游戏状态查询接口
 */
@interface FZGameAppStateQuery : NSObject

/**
 *  查询某个APP的当前状态接口
 *
 *  @param FZGameFile
 *
 *  @return FZGameFile
 */
+(FZGameFile *)queryStateWithObject:(FZGameFile *)fz;

@end
