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
#define didReceiverefreshNotification @"didReceiverefreshNotification"

@interface FZDownloadManager : NSObject <ASIHTTPRequestDelegate,ASIProgressDelegate>

@property(assign) NSUInteger maxDownLoad;//最大下载数
//@property(strong,nonatomic) NSMutableArray *waitDownloadQueue;//等待下载列表
@property(strong,nonatomic) NSMutableArray *overDownloadQueue;//下载完成集合
//@property(strong,nonatomic) NSMutableArray *suspendDownloadQueue;//暂停
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
-(void)stopDownloadUseURL:(NSString *)URL;
/**
 *  重启某个暂停的下载
 *
 *  @param id
 */
-(void)restartDownloadUseURL:(NSString *)URL;

/**
 *  删除一个正在下载的对象
 *
 *  @param mid
 */
-(void)removeOneDownloadingUseURL:(NSString *)URL;
/**
 *  删除一个等待队列中的对象
 *
 *  @param mid 
 */
-(void)removeOneWaittingUseURL:(NSString *)URL;
/**
 *  判断一个app是否在下载队列
 *
 *  @param model
 *
 *  @return
 */
-(Boolean)checkIfDownloading:(id)model;
/**
 *  判断一个app是否在下载完队列
 *
 *  @param model
 *
 *  @return
 */
-(Boolean)checkifOverDownload:(id)model;




@end
