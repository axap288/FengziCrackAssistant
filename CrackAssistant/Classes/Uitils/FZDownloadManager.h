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

//下载状态
typedef enum _downloadState{
    downloading=0,
    waitting =1,
    suspend = 2,
    over=3
}downloadState;

/**
 *  FZGameModel
 */
@interface  FZGameModel : NSObject

@property (strong,nonatomic) NSString *iD;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *fileName;
@property (strong,nonatomic) NSString *downloadUrl;
@property (strong,nonatomic) UIImage *thumbnail;
@property (assign) downloadState state;

@end

/**
 *  FZDownloadDelegate
 */
@protocol FZDownloadDelegate <NSObject>


@end

@interface FZDownloadManager : NSObject <ASIHTTPRequestDelegate>

@property(assign) NSUInteger maxDownLoad;//最大下载数
@property(strong,nonatomic) NSMutableArray *downloadlist;//下载列表
@property(assign) id<FZDownloadDelegate> delegate;


+(FZDownloadManager *)getShareInstance;

/**
 *  添加一个game对象到下载列表
 *
 *  @param model
 */
-(void)addDownloadToList:(FZGameModel *)model;
/**
 *  停止某个下载
 *
 *  @param id
 */
-(void)stopDownloadWithGameId:(NSString *)id;
/**
 *  重启某个暂停的下载
 *
 *  @param id
 */
-(void)restartDownloadWithGameId:(NSString *)id;


@end
