//
//  FZDownloadManager.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-15.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "FZGameFile.h"

#define RefreshDownloadNotification @"RefreshDownloadNotification"

@interface FZDownloadManager : NSObject <ASIHTTPRequestDelegate,ASIProgressDelegate>

@property(assign) NSUInteger maxDownLoad;//最大下载数
@property(strong,nonatomic) NSMutableArray *waitDownloadQueue;//等待下载列表
@property(strong,nonatomic) NSMutableArray *overDownloadQueue;//下载完成集合
@property(strong,nonatomic) NSMutableArray *suspendDownloadQueue;//暂停
@property(strong,nonatomic) NSMutableArray *downloadingQueue;//下载中


+(FZDownloadManager *)getShareInstance;

/**
 *  添加一个game对象到下载列表
 *
 *  @param model
 */
-(void)addDownloadToList:(id)model;
/**
 *  停止某个下载
 *
 *  @param id
 */
-(void)stopDownloadWithGameId:(NSString *)mid;
/**
 *  重启某个暂停的下载
 *
 *  @param id
 */
-(void)restartDownloadWithGameId:(NSString *)mid;

/**
 *  删除一个正在下载的对象
 *
 *  @param mid
 */
-(void)removeOneDownloadingWithGameId:(NSString *)mid;
/**
 *  删除一个等待队列中的对象
 *
 *  @param mid 
 */
-(void)removeOneWaittingWithGameId:(NSString *)mid;




@end
