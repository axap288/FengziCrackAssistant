//
//  FZCommonUitils.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import <Foundation/Foundation.h>
#import "FZAppDelegate.h"

@interface FZCommonUitils : NSObject

+(NSString *)getFileSizeString:(NSString *)size;

+(float)getFileSizeNumber:(NSString *)size;

+ (FZAppDelegate *)getApplicationDelegate;

@end
