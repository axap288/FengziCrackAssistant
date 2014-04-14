//
//  FZNetWorkReachability.h
//  CrackAssistant
//
//  Created by yuan fang on 11-6-5.
//  Copyright 2011 enalex. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <netdb.h>

@protocol FZNetWorkReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end

@interface FZNetWorkReachability : NSObject
+ (BOOL)networkAvailable;
+ (BOOL)activeWWAN;
+ (BOOL)scheduleReachabilityWatcher:(id)watcher;
+ (void)unscheduleReachabilityWatcher;
+ (BOOL)hostAvailable:(NSString *)theHost;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSString *)getIPAddressForHost:(NSString *)theHost;
@end
